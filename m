From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support
 for bio-based dm
Date: Sat, 18 Sep 2010 13:58:12 -0400
Message-ID: <4C94FDB4.7020206@tmr.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
	<1283509796-1510-24-git-send-email-tj@kernel.org>
	<Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
	<20100910184652.GA24470@redhat.com>
	<Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
	<20100910192403.GA24582@redhat.com>
	<Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
	<4C8AC0F5.5080206@kernel.org> <20100911014612.GA26517@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1900925141067755275=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100911014612.GA26517@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: jack@suse.cz, mst@redhat.com, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, hch@lst.de, agk@redhat.com, k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, swhiteho@redhat.com, chris.mason@oracle.com, tytso@MIT.EDU, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--===============1900925141067755275==
Content-Type: multipart/alternative;
	boundary="------------030005010007040705080004"

This is a multi-part message in MIME format.
--------------030005010007040705080004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Snitzer wrote:
> On Fri, Sep 10 2010 at  7:36pm -0400,
> Tejun Heo<tj@kernel.org>  wrote:
>
>    
>> On 09/10/2010 10:06 PM, Mikulas Patocka wrote:
>>      
>>> But I have my work rules that I learned: I use no git kernels and no
>>> external patches (except Alasdair's patchset that I want to test). I only
>>> use -rc or final kernels. I need a stable computer --- I don't want to
>>> solve problems like "does it crash because I pulled something or does it
>>> crash because I made a bug in my code?" So, put that into 2.6.37-rc1 and
>>> I'll optimize flushes in dm for -rc2 or -rc3.
>>>        
>> Alright, I'm sorry but this is as far as I would go for dm conversion
>> patches.  If you wanna split it further or do it your way, please feel
>> free to.  I think it would be beneficial to do things now but, hey,
>> you guys are maintaining dm part of the kernel, so it's up to you
>> guys.  But, I think it would be silly for everyone else to wait for
>> the rather special requirement for dm, so if we have to go forward
>> without dm updates, I suppose we will have to.  Jens, please feel free
>> to drop dm conversion patches.
>>      
> Tejun,
>
> Mikulas doesn't speak for Alasdair or the rest of the DM developers.  He
> speaks for himself.  He, like me, is a member of the team that helps
> maintain DM.  But Alasdair is the upstream DM maintainer.
>
> Please don't latch on to Mikulas' disruptive stone-walling.  As I shared
> in my previous reply: your FLUSH+FUA contributions to DM are very much
> appreciated!  Kiyoshi, Jun'ichi and myself have all worked with you
> effectively and so far the end result DM conversion has proven quite
> stable and correct.  Wider testing via linux-next is an important next
> step.
>
> Jens, please don't drop the DM FLUSH+FUA conversion patches from your
> 'for-next' branch.  Mikulas has yet to offer a single substantive
> criticism of the code in question.
>    

He is commenting on the process rather than the code, since he tells you 
that he lacks time to review your complex changes to his work, so your 
saying that he hasn't found errors in it is muddy thinking as best.

He provided a patch and would like it tested properly before you drop a 
bunch of stuff on top of it, to be sure it gets proper exposure and 
wider testing. That sounds like sound software development to me. It 
sounds as though you feel that the inclusion of your additional work is 
critical and can't possibly wait until the next -rc or release, and I 
have missed the reason why your stuff can't wait until it can drop on 
mainline code..

-- 
Bill Davidsen<davidsen@tmr.com>
   "We can't solve today's problems by using the same thinking we
    used in creating them." - Einstein


--------------030005010007040705080004
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
Mike Snitzer wrote:
<blockquote cite="mid:20100911014612.GA26517@redhat.com" type="cite">
  <pre wrap="">On Fri, Sep 10 2010 at  7:36pm -0400,
Tejun Heo <a class="moz-txt-link-rfc2396E" href="mailto:tj@kernel.org">&lt;tj@kernel.org&gt;</a> wrote:

  </pre>
  <blockquote type="cite">
    <pre wrap="">On 09/10/2010 10:06 PM, Mikulas Patocka wrote:
    </pre>
    <blockquote type="cite">
      <pre wrap="">But I have my work rules that I learned: I use no git kernels and no 
external patches (except Alasdair's patchset that I want to test). I only 
use -rc or final kernels. I need a stable computer --- I don't want to 
solve problems like "does it crash because I pulled something or does it 
crash because I made a bug in my code?" So, put that into 2.6.37-rc1 and 
I'll optimize flushes in dm for -rc2 or -rc3.
      </pre>
    </blockquote>
    <pre wrap="">
Alright, I'm sorry but this is as far as I would go for dm conversion
patches.  If you wanna split it further or do it your way, please feel
free to.  I think it would be beneficial to do things now but, hey,
you guys are maintaining dm part of the kernel, so it's up to you
guys.  But, I think it would be silly for everyone else to wait for
the rather special requirement for dm, so if we have to go forward
without dm updates, I suppose we will have to.  Jens, please feel free
to drop dm conversion patches.
    </pre>
  </blockquote>
  <pre wrap="">
Tejun,

Mikulas doesn't speak for Alasdair or the rest of the DM developers.  He
speaks for himself.  He, like me, is a member of the team that helps
maintain DM.  But Alasdair is the upstream DM maintainer.

Please don't latch on to Mikulas' disruptive stone-walling.  As I shared
in my previous reply: your FLUSH+FUA contributions to DM are very much
appreciated!  Kiyoshi, Jun'ichi and myself have all worked with you
effectively and so far the end result DM conversion has proven quite
stable and correct.  Wider testing via linux-next is an important next
step.

Jens, please don't drop the DM FLUSH+FUA conversion patches from your
'for-next' branch.  Mikulas has yet to offer a single substantive
criticism of the code in question.
  </pre>
</blockquote>
<br>
<font size="+1">He is commenting on the process rather than the code,
since he tells you that he lacks time to review your complex changes to
his work, so your saying that he hasn't found errors in it is muddy
thinking as best.<br>
<br>
He provided a patch and would like it tested properly before you drop a
bunch of stuff on top of it, to be sure it gets proper exposure and
wider testing. That sounds like sound software development to me. It
sounds as though you feel that the inclusion of your additional work is
critical and can't possibly wait until the next -rc or release, and I
have missed the reason why your stuff can't wait until it can drop on
mainline code..</font><br>
<pre class="moz-signature" cols="80">-- 
Bill Davidsen <a class="moz-txt-link-rfc2396E" href="mailto:davidsen@tmr.com">&lt;davidsen@tmr.com&gt;</a>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein
</pre>
</body>
</html>

--------------030005010007040705080004--


--===============1900925141067755275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1900925141067755275==--
