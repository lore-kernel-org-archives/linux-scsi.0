From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] really large storage sectors - going beyond 4096
 bytes
Date: Wed, 22 Jan 2014 08:14:47 +0100
Message-ID: <52DF6FE7.2080901@suse.de>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com> <20140122052052.GM10565@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140122052052.GM10565@ZenIV.linux.org.uk>
Sender: owner-linux-mm@kvack.org
To: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/22/2014 06:20 AM, Joel Becker wrote:
> On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
>> One topic that has been lurking forever at the edges is the current
>> 4k limitation for file system block sizes. Some devices in
>> production today and others coming soon have larger sectors and it
>> would be interesting to see if it is time to poke at this topic
>> again.
>>
>> LSF/MM seems to be pretty much the only event of the year that most
>> of the key people will be present, so should be a great topic for a
>> joint session.
>=20
> Oh yes, I want in on this.  We handle 4k/16k/64k pages "seamlessly," an=
d
> we would want to do the same for larger sectors.  In theory, our code
> should handle it with the appropriate defines updated.
>=20
+1

The shingled drive folks would really love us for this.
Plus it would make live really easy for those type of devices.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
