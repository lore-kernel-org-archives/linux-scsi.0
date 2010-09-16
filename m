From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 00/33] bfa: Brocade BFA FC SCSI driver v2.3.2.0 submission.
Date: Thu, 16 Sep 2010 10:10:21 -0400
Message-ID: <4C92254D.7030304@redhat.com>
References: <1284576649-12684-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0IPOPl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 10:15:41 -0400
In-Reply-To: <1284576649-12684-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com

kgudipat@brocade.com wrote:
> From: Krishna Gudipati <kgudipat@brocade.com>
>
> Hi James,
>
> This is the cleaned up Brocade BFA FC SCSI driver v2.3.2.0 submission.
>
> We have flattened the BFA hierarchy and also reduced the number of
> source and header files we used to have earlier.
>
> This patchset is organized as follows:
>
> 	- The initial 15 patches will be cleaning up the current existing code as follows:
>
> 	  a) We flattened the BFA, removed unused source/header files & merged related ones.
>
> 	  b) We removed some of the files first even though they are going to stay in the new
> 	     2.3.2.0 cleaned up BFA, since this will make reviewing the code easier, else the
> 	     diff gets really confusing. Hope its ok.
>
> 	- The next 18 patches will pull back in the cleaned up 2.3.2.0 based BFA driver and
> 	  the changes that were needed while flattening / cleaning up the BFA driver.
>
> I have compiled & tested the code against your scsi-misc and net-next (2.6.36-rc3-0-3-default).
>   

Your patch set seems to skip 1/33.

I applied patch 2/33 to scsi-misc-2.6 that I cloned this morning.
The last tag was v2.6.36-rc3
I saw several instances of 'Reversed (or previously applied) patch 
detected', see below.

Is there a particular tag I need to use?

Thanks, Rob

patching file drivers/scsi/bfa/bfa_fcport.c
Reversed (or previously applied) patch detected!  Assume -R? [n] n
Apply anyway? [n] n
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file 
drivers/scsi/bfa/bfa_fcport.c.rej
patching file drivers/scsi/bfa/bfa_fcxp.c
Reversed (or previously applied) patch detected!  Assume -R? [n] n
Apply anyway? [n] n
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file 
drivers/scsi/bfa/bfa_fcxp.c.rej


