From: David Caldwell <david@porkrind.org>
Subject: Re: [PATCH] Reimplement the SG_FLAG_LUN_INHIBIT flag in sg's
 SG_IOCTL.
Date: Sun, 18 Dec 2005 18:44:16 -0800
Message-ID: <1265DA04D7476A91BFE5A61E@bluey.local>
References: <20051216215447.GA25090@porkrind.org>
 <20051217122802.GA12725@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-67-49-70-252.socal.res.rr.com ([67.49.70.252]:13038 "EHLO
	death.porkrind.org") by vger.kernel.org with ESMTP id S932460AbVLSCoW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2005 21:44:22 -0500
Received: from [10.0.0.2] ([10.0.0.2])
	(authenticated bits=0)
	by death.porkrind.org (8.13.5/8.13.5/Debian-3) with ESMTP id jBJ2iGPw018927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 18 Dec 2005 18:44:18 -0800
In-Reply-To: <20051217122802.GA12725@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 12/17/05 12:28 PM +0000 Christoph Hellwig wrote:

> On Fri, Dec 16, 2005 at 01:54:51PM -0800, David Caldwell wrote:
>> scsi.c will normally overwrite the second byte of the command with the
>> appropriate LUN info if the device is a SCSI 2 device. I have a device
>> that uses the second byte of the cdb for something other than the LUN
>> (yes, it is a stupid broken device). This flag allows such broken
>> devices work.
>
> scsi_request is hopefully not going to survive 2.6.16 so at this point
> this patch is not interesting in this form.

Have you started this work yet? I can re-implement the patch in the latest 
code base if you can point me to it.

If not, then why not take the patch? It's only 3 lines of code! Then it 
becomes just another [small] part of the restructuring work that is 
planned. In the worst case it can be removed at that point if it's really 
annoying to think about.

-David
