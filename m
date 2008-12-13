From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Sat, 13 Dec 2008 18:35:06 +0300
Message-ID: <4943D62A.4060900@vlnb.net>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>	 <54939.1229149205@turing-police.cc.vt.edu>	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>	 <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com> <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:53531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYLMPey (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Dec 2008 10:34:54 -0500
In-Reply-To: <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, scst-devel <scst-devel@lists.sourceforge.net>, Bart Van Assche <bart.vanassche@gmail.com>



Nicholas A. Bellinger wrote:
> On Sat, 2008-12-13 at 11:23 +0100, Bart Van Assche wrote:
>> On Sat, Dec 13, 2008 at 11:08 AM, Nicholas A. Bellinger <nab@kernel.org> wrote:
>>>> See also:
>>>> * February 1, 2008, LIO kernel panic during configuration,
>>>> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/74c8b37f24b84e59/d94c07626bd20521?lnk=gst&q=kernel+panic#d94c07626bd20521.
>>>> * February 8, 2008, kernel crash triggered by LIO,
>>>> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/30835aede1028188/5708e16a23367fb4?lnk=gst&q=kernel+crash#5708e16a23367fb4.
>>>> * February 13, 2008, LIO target kernel code triggers memory
>>>> corruption, http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/ddc1bf7666372972/2150a09f9ed3d1cd?lnk=gst&q=ipoib#2150a09f9ed3d1cd.
>>>> * February 18, 2008, LIO target makes entire system hang,
>>>> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/6a76f9efd9409fc5/55bd8840b6a5f757?lnk=gst&q=lio+target+hangs#55bd8840b6a5f757.
>>>>
>>> I have no idea why why you keep bringing up a minor BUG (completely
>>> unrelated to Target_Core_Mod/ConfigFS and LIO-Target v3.0 btw) that was
>>> fixed 10 months ago..?  Perhaps if you spent half the time looking at
>>> actual lio-core-2.6.git code that you do bringing up minor closed bugs
>>> from months ago [ ... ]
>> I won't comment on the fact that you consider a kernel crash or a
>> system hang as a minor bug.
>>
> 
> The problem is that you like to handwave on the technical issues, just
> like you are doing here.  :-)  Of course I fix bugs when people report
> them, but when people like yourself yell and scream and handwave, it
> makes me not want to fix it as quickly if someone wrote a nice and
> thoughful email and said 'thank you'.
> 
> Anyways, I am not going to debate the development process with you, and
> as folks on the LIO-devel list can tell you, I am very quick to produce
> patches when a issue is located.  
> 
>> I reported four bugs instead of one. Only two of these have been
>> reported to be fixed.
>>
> 
> Considering you said earlier that you have not actually looked at any
> recently LIO code, how could you know these bugs are fixed..?   Back
> here in the land of reality, these *TWO* bugs where fixed in back Feb.
> One was related to iSCSI discovery, and one related to v2.6.24 kernel
> breakage and struct scatterlist->page_link, so what..?  Do you honestly
> think handwaving about bugs from 10 months ago will get you anywhere
> here..?  If you are so certain these bugs still exist or have any effect
> on my upstream work, then please, go ahead and prove it.  No..? I did
> not think so.
> 
> What does any of this have to do with lio-core-2.6.git,
> Target_Core_Mod/ConfigFS and LIO-Target v3.0 btw..?  Are you actually
> going to write a thoughtful or relivent comment on the v3.0 design
> and/or code, because that would be nice out of your for once.  Otherwise
> I am going to ignore you again, just the like conversation where you
> said:
> 
> "Zero-copy means that data is copied as few times as possible".
> 
> when I was attempting to explain the finer pointers of
> Target_Core_Mod/ConfigFS design to you and Vlad.  Remember that one..?
> 
> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/8cff61671cd2de6b/37ade00e607dd8c8

You know, that thread was finished when you refused to name which real 
life tasks you are going to solve with your super advanced features. 
I.e. answer, why are they needed at all?

Vlad

