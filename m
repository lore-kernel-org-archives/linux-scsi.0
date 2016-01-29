From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [LSF/MM TOPIC] LIO/SCST Merger
Date: Thu, 28 Jan 2016 18:57:38 -0800
Message-ID: <56AAD522.9050604@vlnb.net>
References: <56A9043B.7030207@sandisk.com> <1453963019.6746.244.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1453963019.6746.244.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Nicholas A. Bellinger wrote on 01/27/2016 10:36 PM:
> On Wed, 2016-01-27 at 09:54 -0800, Bart Van Assche wrote:
>> Last year, during the 2015 LSF/MM summit, it has been decided that the 
>> LIO/SCST merger project should proceed by sending the functionality 
>> upstream that is present in SCST but not yet in LIO. This will help to 
>> reduce the workload of target driver maintainers that maintain a version 
>> of their target driver for both LIO and SCST (QLogic FC and FCoE target 
>> drivers, Emulex FC and FCoE target drivers, RDMA iSER target driver, 
>> RDMA SRP target driver, ...). My proposal is to organize a session 
>> during which the following is discussed:
>> * Which patches are already upstream in the context of the LIO/SCST 
>> merger project.
>> * About which patches there is agreement but that are not yet upstream.
>> * To discuss how to proceed from here and what to address first.
> 
> No, just no.  If you've not been able to articulate the specifics of
> what you're talking about to the list by now, it's never going to
> happen.
> 
> You'll recall last year how things unfolded at LSF.  You started
> comparing data structure TMR member names of no consequence to a larger
> LSF audience, and quickly tried to pivot into a discussion about adding
> hooks to LIO fabric drivers for your own out-of-tree nastiness.
> 
> I really fail to see how that helps LIO or upstream.  To repeat.  I'll
> not allow SCST's out-of-tree legacy requirements to limit LIO's future
> in upstream, and if you or your employer is still trying to get
> enterprise distros to listen to that nonsense behind the scenes, then
> please stop wasting everybody's time.
> 
> Bart, I really want to believe you and your employer have good
> intentions for LIO.  However, being one of it's largest detractors in
> the past means that you have to really put your best foot forward on
> your interaction with the LIO community.
> 
> However, your inability to ask questions before acting, refusing to
> answer to all feedback on reviews for changes of substance, and not
> following the expected patch review progress without repeatably leading
> yourself and others down the wrong path really makes me start to
> question your intentions, or at least your abilities as a kernel
> contributor.
> 
> Also, you've not managed to merge any of the outstanding ib_srpt fixes
> from the last year, which brings us to a grad total of 6 small patches
> since the original merge of ib_srpt in Oct 2011.
> 
> # git log --author=Bart --oneline -- drivers/infiniband/ulp/srpt/
> 19f5729 IB/srpt: Fix the RDMA completion handlers
> ba92999 target: Minimize SCSI header #include directives
> 2fe6e72 ib_srpt: Remove set-but-not-used variables
> 649ee05 target: Move task tag into struct se_cmd + support 64-bit tags
> afc1660 target: Remove first argument of target_{get,put}_sess_cmd()
> ab477c1 srp-target: Retry when QP creation fails with ENOMEM
> 
> That's really a terrible record.
> 
> So until you're able to demonstrate publicly to me and the LIO community
> that you do have good intentions, and not trying to rehash the same
> tired old nonsense and willful ignorance, please stop throwing out these
> generic topics as a branding exercise.
> 
> There are much more interesting and important topics at LSF to discuss.

While I'm generally refraining from feeding trolls, don't you think that a person who
has contributed you one of the major drivers and continues making such important
contributions (for free!) trying to bring (eventually, after how many years?) LIO
reliability to something you can compare to SCST, deserves a little more respect?

Vlad
