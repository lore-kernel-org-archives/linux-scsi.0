From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to the
 tcm_qla2xxx module - revision3
Date: Tue, 29 Mar 2016 22:05:28 -0700
Message-ID: <56FB5E98.9010103@sandisk.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:25203
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750978AbcC3FFk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 01:05:40 -0400
In-Reply-To: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 03/29/16 07:42, Laurence Oberman wrote:
> I have been using this jammer functionality to continue testing the SCSI F/C drivers and recovery for over a year now.
> Any chance you would agree to ack this so I can get it in now.
> I last posted to the list last March and it was not picked up.
>
> I did look into moving this to upper layers but I find I use it primarily for fiber channel target testing.
> Attempting to add this functionality to upper layers led to complexities and this is very solid.
>
> This Patch diff against 4.5
>
> I use target LIO for all my storage array test targets and customer problem resolution here at Red Hat.
> This patch resulted from a requirement to mimic behavior of an expensive hardware jammer for a customer.
> I have used this for some time with good success to simulate and reproduce latency and slow drain fabric issues and
> for testing and validating error handling behavior
>   in the Emulex, Qlogic and other F/C drivers.
>
> Works by checking new parameter jam_host if its >= 0 and matches vha->host_no , jamming is enabled when jam_host >=0
> If parameter set to -1 (default) no jamming is enabled.

Hello Laurence,

Nic Bellinger is the maintainer of LIO so my recommendation is to ask 
Nic first about his opinion (I have CC'd Nic). I'm not sure what Nic 
thinks about this but in my opinion such functionality belongs in the 
target core instead of in a target driver. But please wait until Nic has 
provided his opinion before spending more time on this. The mailing list 
for SCSI target patches is target-devel@vger.kernel.org.

Bart.
