From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 23/32] cxlflash: Fix function prolog parameters and return codes
Date: Tue, 29 Sep 2015 15:31:28 -0500
Message-ID: <5311CCA4-21BF-4D85-90FF-2984C8C22BB9@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223098-9809-1-git-send-email-mrochs@linux.vnet.ibm.com> <560A153B.5000101@au1.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:34525 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbbI2Udu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 16:33:50 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 29 Sep 2015 14:33:49 -0600
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 6E49FC9003C
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 16:24:50 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8TKXl2j16449774
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 20:33:47 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8TKXiSC025832
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 16:33:46 -0400
In-Reply-To: <560A153B.5000101@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 28, 2015, at 11:36 PM, Andrew Donnellan <andrew.donnellan@au1.ibm.com> wrote:
> On 26/09/15 09:18, Matthew R. Ochs wrote:
>> 
>>   */
>>  static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
>>  {
>> @@ -491,9 +490,7 @@ static const char *cxlflash_driver_info(struct Scsi_Host *host)
>>   * @host:	SCSI host associated with device.
>>   * @scp:	SCSI command to send.
>>   *
>> - * Return:
>> - *	0 on success
>> - *	SCSI_MLQUEUE_HOST_BUSY when host is busy
>> + * Return: 0 on success or SCSI_MLQUEUE_HOST_BUSY
>>   */
> 
> I'd prefer it to say "SCSI_MLQUEUE_HOST_BUSY on failure". (Aesthetically I prefer having it on a separate line, but that's just personal preference.)
> 
> As an aside, while checking the correctness of this, I found that the comment for cxlflash_send_cmd() states that it returns -1 on failure, when the only error value it actually returns is SCSI_MLQUEUE_HOST_BUSY. If you send a v5 you might want to fix this.

I'll make a note of this.

