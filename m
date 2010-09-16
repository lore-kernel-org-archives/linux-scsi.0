From: Krishna Gudipati <kgudipat@Brocade.com>
Subject: RE: [PATCH 00/33] bfa: Brocade BFA FC SCSI driver v2.3.2.0
 submission.
Date: Thu, 16 Sep 2010 07:32:23 -0700
Message-ID: <5EB1A55E180C914BBC1A49310B7629386690401D4B@HQ1-EXCH02.corp.brocade.com>
References: <1284576649-12684-1-git-send-email-kgudipat@brocade.com>
 <4C92254D.7030304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:51847 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab0IPOcn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 10:32:43 -0400
In-Reply-To: <4C92254D.7030304@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jing Huang <huangj@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Akshay Mathur <amathur@brocade.com>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

-----Original Message-----
From: Rob Evers [mailto:revers@redhat.com] 

Your patch set seems to skip 1/33.

I applied patch 2/33 to scsi-misc-2.6 that I cloned this morning.
The last tag was v2.6.36-rc3
I saw several instances of 'Reversed (or previously applied) patch 
detected', see below.

Is there a particular tag I need to use?

Thanks, Rob

>>>

Hi Rob,

I did resend the patch1/33 twice, but it was never showing up in the linux-scsi mailing list.
I am resending it to you and to the community again.

Regarding applying the patches: I used patch -p1 < <patch> while applying to scsi-misc and net-next.

I am cloning today's scsi-misc to see something has changed. But please try applying 0001 and then so on.

thx.
