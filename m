From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: RE: One question about SCSI device hotplug
Date: Wed, 2 Mar 2005 09:10:36 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB051E6CDB@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Received: from ngate.noida.hcltech.com ([202.54.110.230]:26300 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S262136AbVCBDnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 22:43:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "Zhao, Forrest" <forrest.zhao@intel.com>
Cc: linux-scsi@vger.kernel.org, "Caushik, Ramesh" <ramesh.caushik@intel.com>



What surprises me is that if the LLDD *can't* get to know about the hot
plugging / unplugging of device, what is the use of the functions
scsi_add_device() and scsi_remove_device()??

Please note that these functions are provided by scsi mid-level driver to
LLDD to add / remove devices (Refer to
Documentation/scsi/scsi_mid_low_api.txt).

Thanks & Regards,

Rajat Jain
HCL Technologies,
A-11, Sector 16, Noida-201301.
Ph: +91-120-2510701/702/813 Extn.3159
rajatj@noida.hcltech.com
http://www.hcltech.com/ 

	"...one of the main causes of the fall of the Roman Empire was that,
lacking zero, they had no way to indicate successful termination of their C
programs."
	Robert Firth 





-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Matthew Wilcox
Sent: Tuesday, March 01, 2005 8:16 PM
To: Zhao, Forrest
Cc: linux-scsi@vger.kernel.org; Caushik, Ramesh
Subject: Re: One question about SCSI device hotplug

On Tue, Mar 01, 2005 at 05:06:55PM +0800, Zhao, Forrest wrote:
> If I surprisingly hot-remove a SCSI disk from HBA manually without 
> executing "echo "scsi remove-single-device  <h> <b> <t <l>" > 
> /proc/scsi/scsi", can the "hotplug"
> event be notified to SCSI mid-layer or user space?
> 
> I briefly browse some code of LLDD, it seems that LLDD never report 
> "hotplug" event to upper-level layer. Am I right?

I don't think it *can* ... the SCSI protocols don't tell the host "hey, this
device has disappeared".

--
"Next the statesmen will invent cheap lies, putting the blame upon the
nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse to
examine any refutations of them; and thus he will by and by convince himself
that the war is just, and will thank God for the better sleep he enjoys
after this process of grotesque self-deception." -- Mark Twain
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
