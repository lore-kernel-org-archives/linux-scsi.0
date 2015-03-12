From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH ] tcm_qla2xxx  Add SCSI command jammer/discard capabilty
 to the tcm_qla2xxx module - revision2
Date: Thu, 12 Mar 2015 13:13:28 +0000
Message-ID: <5EE87F5E6631894E80EB1A63198F964D042063ED@SACMBXIP03.sdcorp.global.sandisk.com>
References: <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com>
 <54FC03FA.6000005@sandisk.com>
 <629323685.13531146.1425829095558.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0069.outbound.protection.outlook.com ([65.55.169.69]:12000
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754159AbbCLNNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2015 09:13:33 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Andy Grover <agrover@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@daterainc.com" <nab@daterainc.com>, Laurence Oberman <oberman.l@gmail.com>

On 03/08/2015 11:38 AM, Laurence Oberman wrote:
> Here is revision2
>
> I added unlikely and removed messaging control as it not necessary and adds overhead.
>
> I use target LIO for all my storage array test targets and customer problem resolution here at Red Hat.
> This patch resulted from a requirement to mimic behaviour of an expensive hardware jammer for a customer.
> I have used this for some time with good success to simulate and reproduce latency and slow drain fabric issues and
> for testing and validating error handling behaviour in the Emulex, Qlogic and other F/C drivers.
>
> Works by checking new parameter jam_host if its >= 0 and matches vha->host_no , jamming is enabled when jam_host >=0
> If parameter set to -1 (default) no jamming is enabled.
> I decided to share the patch, in the hope it may be useful for others but I do understand this is a special use case.

Hello Laurence,

Thanks for reworking this patch quickly. This patch looks fine to me. 
The only remaining concern I have is that I'm wondering what the best 
place would be to add this functionality - the qla2xxx driver or the LIO 
core ?

Bart.
