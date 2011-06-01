From: Artur Wojcik <artur.wojcik@intel.com>
Subject: Re: [PATCH] libsas: add SMP READ/WRTIE GPIO support
Date: Wed, 01 Jun 2011 19:02:07 +0200
Message-ID: <4DE6708F.8080604@intel.com>
References: <20110601140203.26324.22849.stgit@gklab-128-184.igk.intel.com> <4DE64D78.6090309@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab1FARCX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 13:02:23 -0400
In-Reply-To: <4DE64D78.6090309@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 06/01/2011 04:32 PM, Douglas Gilbert wrote:
> On 11-06-01 10:02 AM, Artur Wojcik wrote:
>> This patch enables the SMP READ/WRITE GPIO function interface in 
>> libsas SMP
>> host module. The interface is used to control the SGPIO initiator in 
>> the SAS
>> initiator. The implementation is SFF-8485 and SAS-2 compliant.
>>
>> There are two functions in transport class only responsible for 
>> reading and
>> writting GPIO registers. I decided to leave the decission about what 
>> type of
>> registers are supported to lldd.
>>
>> Now the user space application may issue SMP READ/WRITE GPIO frame to 
>> HBA in
>> order to read/write GPIO registers.
>
> Your code also accepts the somewhat mysterious READ GPIO
> REGISTER ENHANCED SMP function and its WRITE equivalent.
> Reference is made in sas2r16.pdf to SFF-8485 for those
> functions. However the most recent version of SFF-8485
> on the Seagate site is 0.7 dated February 2006, and it does
> not define those ENHANCED functions.
>
> Could you tell us what those ENHANCED versions do?
>
> Doug Gilbert
I have not found the description of ENHANCED frames in any publicly 
available specification related to SGPIO. I took SAS-2 as the major 
reference and it says SMP functions 02h (READ) and 82h (WRITE) are 
obsolete. My understanding is that for the moment the new functions are 
replacing the deprecated functions, but the frame format and registers 
set stay the same.

Artur Wojcik

