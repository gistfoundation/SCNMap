import com.the6hours.grails.springsecurity.twitter.TwitterUserDomain
import net.thegistgub.scnmap.Person

class TwitterUser implements TwitterUserDomain {

    int uid
    String screenName
    String tokenSecret
    String token

	static belongsTo = [user: Person]

	static constraints = {
		uid unique: true
	}
}
