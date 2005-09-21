From: Jody McIntyre <scjody@steamballoon.com>
Subject: Re: [PATCH 2.6.14-rc1 0/13] ieee1394: fixes and cleanups
Date: Tue, 20 Sep 2005 20:46:50 -0400
Message-ID: <20050921004650.GG1114@conscoop.ottawa.on.ca>
References: <200509172308.j8HN8ZcH030215@einhorn.in-berlin.de> <20050920213121.GB1114@conscoop.ottawa.on.ca> <43309010.6010205@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <43309010.6010205@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Ben Collins <bcollins@debian.org>, Dan Dennedy <dan@dennedy.org>, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 21, 2005 at 12:41:20AM +0200, Stefan Richter wrote:

> What Linus and Andrew do with these patches is ultimately up to them. In 
> my opinion they could/should go straight into Linus' tree because they 
> are ...well... fixes and cleanups. There are no new features, no risky 
> rewrites.

No, it's basically up to us.  If I send them to Andrew, they'll go into
-mm.  If I send them to Linus, there's a really good chance they'll go
straight into his tree (since it's still open for bugfixes, and that's
what they are.)  It sounds like the latter is what you want.  Does
anyone else have any concerns with doing this?

> [...]

I realize the RBC change was missing.  I assumed you were still working
on it, as well as a couple of others.

> This is actually another reason why the other patches should better go 
> into Linus' tree already. We have to have released kernels with an sbp2 
> driver that actually works. Only a working, released kernel as basis of 
> reference makes it possible to actually test changes like the RBC 
> related ones.

Well, in my testing, we had that as of 2.6.12 :)  But I realize from
reading the list that others still experience problems with sbp2.
(How's that for a huge understatement? :)

> Also note: Incarnations of the sbp2 hot-unplug patch, the whole 
> serialize_io matter, and patch 5/13 (reordering to nodemgr's IRM duties) 
> have actually received testing by kind readers of linux1394-devel and 
> linux1394-user. This is certainly a different circle of testers than 
> those who are running -mm kernels. However it's a very valid way of 
> testing because there were _fixes_ to test, not new features or code 

That's true, but I don't really have a sense for how many users this
represents, especially given that svn is down.  -mm is the official
"pre Linus testing" tree, so putting it in there is as good as it
gets...

> (That was a long answer... However, don't take me wrong. I don't want to 
> push anything and I don't have strong feelings what should happen with 
> the patches.)
> 
> >In any case,
> >they should be sent in by Ben or myself, to avoid confusing people :)
> 
> Well, _somebody_ should do it. :-)
> And I agree that confusion should be avoided. No need to add more 
> friction to the process.

OK.  Well, since Ben did say he would do this from now on, how about I
wait until late Thursday (your original stated deadline) and send them
up, unless Ben steps in beforehand and confirms he will still do it.


Cheers,
Jody

> -- 
> Stefan Richter
> -=====-=-=-= =--= =-=--
> http://arcgraph.de/sr/

-- 


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
