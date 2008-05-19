From: <Shyam_Iyer@Dell.com>
Subject: RE: [dm-devel] Re: [PATCH 7/7] scsi_dh: attach to hardware handler fromdm-mpath
Date: Tue, 20 May 2008 00:41:24 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CA01618D5D@blrx3m10.blr.amer.dell.com>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>	<1210819801.21974.266.camel@chandra-ubuntu><482C0676.9070004@suse.de><1210964001.21974.351.camel@chandra-ubuntu> <483154B0.7020500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:22011 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYESTLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 15:11:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <483154B0.7020500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, sekharan@us.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>Chandra Seetharaman wrote:
>> Hence, there is no need to attach it again from the multipath layer.

 Hannes Reinecke wrote:
>Yes, you do. The user might have it's own custom configuration file,
covering new/unknown/unhandled/testing devices, which out of necessity
are _not_
>hardcoded in the device table of the device handler.
>So multipath has to have a way of attaching device handler to those
devices, too. 

Quite agree. There are a lot of OEM vendors that may use for example the
LSI RDAC conrtoller but the SCSI inquiry for these devices return the
OEM device names. 
The DELL MD3000 is an example of such a box. Instead of hardcoding
device tables of the handler if they could be configured using a custom
configuration file enabling new hardware becomes such a bliss.

-Shyam Iyer

