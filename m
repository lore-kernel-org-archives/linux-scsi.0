From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid: Host adapter reset request. SCSI hang ? Adaptec 2820SA
Date: Mon, 9 Oct 2006 08:12:25 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02D80FA9@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:28894 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751858AbWJIMM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2006 08:12:27 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>, linux-scsi@vger.kernel.org

The usual cause for this is that the bus, or the drives, are in trouble.
The driver and the OS are merely responding to a serious hardware
failure.

My first suggestion is to ensure that you have the latest available
firmware in the controller and in the drives. Problems crop up if the
power supplies are not capable of dealing with the load, make sure you
have adequate power budget for all peak power consumption requirements.
If drive compatibility is in question, then I suggest contacting the
drive vendor, and Adaptec Technical support to determine if there is an
issue. Possibilities include utilizing the WD JD series drives, as they
are not compatible with any Hardware RAID cards. WD has a program where
they will replace your drives with RAID compatible units. Check SATA/SAS
cables and routing as well as cooling for both the drives and the
controller card.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Simon Matthews
> Sent: Friday, October 06, 2006 5:23 PM
> To: linux-scsi@vger.kernel.org
> Subject: aacraid: Host adapter reset request. SCSI hang ? 
> Adaptec 2820SA
> 
> 
> I am seeing the above message in logs.
> 
> Some times the system locks up, some times it continues. The OS
> resides on the RAID array, so if the controller goes offline, the
> system cannot continue running.
> 
> Any ideas what might be causing this?
> 
> I am running a RedHat AMD64 system, with kernel: 2.6.9-34.EL and
> aacraid module version 1.1-5[2425].
> 
> More info:
> #   grep aac /var/log/dmesg
> Adaptec aacraid driver (1.1-5[2425])
> aacraid0: kernel 5.1-0[9117]
> aacraid0: monitor 5.1-0[9117]
> aacraid0: bios 5.1-0[9117]
> aacraid0: serial 504e8b
> scsi0 : aacraid
> 
> Does anyone have any suggestions? The system has hung twice within the
> space of 2 hours, so this is not good!
> 
> Regards,
> Simon
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
