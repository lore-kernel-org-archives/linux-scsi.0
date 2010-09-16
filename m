From: Krishna Gudipati <kgudipat@Brocade.com>
Subject: RE: [PATCH 00/33] bfa: Brocade BFA FC SCSI driver v2.3.2.0
 submission.
Date: Thu, 16 Sep 2010 07:50:04 -0700
Message-ID: <5EB1A55E180C914BBC1A49310B7629386690401D55@HQ1-EXCH02.corp.brocade.com>
References: <1284576649-12684-1-git-send-email-kgudipat@brocade.com>
 <4C92254D.7030304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:52549 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab0IPOuT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 10:50:19 -0400
In-Reply-To: <4C92254D.7030304@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jing Huang <huangj@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Akshay Mathur <amathur@brocade.com>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

-----Original Message-----
From: Rob Evers [mailto:revers@redhat.com] 
Sent: Thursday, September 16, 2010 7:10 AM
To: Krishna Gudipati
Cc: James.Bottomley@suse.de; linux-scsi@vger.kernel.org; Jing Huang; Vinodh Ravindran; Ramkumar Vadivelu; Akshay Mathur; Adapter Linux Open SRC Team
Subject: Re: [PATCH 00/33] bfa: Brocade BFA FC SCSI driver v2.3.2.0 submission.
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

>>>>

Hi Rob,

Just an update, I just cloned scsi-misc and patch -p1 < <patch> did not give me any rejects.
I was able to patch it:

kgudipat@blc-10-3:$ patch -p1 < ../scsi-misc-new/patches/0002-bfa-Cleanup-Patch-Remove-the-per-BFA-sub-module-file.patch
patching file drivers/scsi/bfa/bfa_fcport.c
patching file drivers/scsi/bfa/bfa_fcxp.c
patching file drivers/scsi/bfa/bfa_lps.c
patching file drivers/scsi/bfa/bfa_rport.c
patching file drivers/scsi/bfa/bfa_sgpg.c
patching file drivers/scsi/bfa/bfa_uf.c
patching file drivers/scsi/bfa/plog.c

thx.


