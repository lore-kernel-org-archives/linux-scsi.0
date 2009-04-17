From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and implementation.
Date: Fri, 17 Apr 2009 10:27:20 -0400
Message-ID: <49E891C8.1050007@emulex.com>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> <49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com> <49E88E3F.8030107@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57236 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337AbZDQO1c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 10:27:32 -0400
In-Reply-To: <49E88E3F.8030107@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Daniel Debonzi <debonzi@linux.vnet.ibm.com>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Vladislav Bolkhovitin wrote:
> Let's go with root in /sys/class/scsi_tgt. In future, if somebody 
> objects, we can easily change it.
>   

This maps too closely to the scsi midlayer names, especially the real 
target devices initiators see - which are not yet in sysfs but there has 
been discussion of in the past. I would prefer that you used 
/sys/class/scst_tgt.  And yes, as part of the class level support in the 
midlayer/kernel, they are generally symlinks to the actual kobject in 
the /sys/devices that the class entity corresponds to.

IMHO - "scsi_tgt" also seems a bit presumptuous to propose if SCST is 
not, in it's entirety, going to be the adapter target interface pulled 
in upstream.  Thus, another reason I prefer the "scst_tgt" name, as it 
makes it very specific to SCST itself, and lessens any co-existence 
conflicts if there are any in the future.

-- james s
