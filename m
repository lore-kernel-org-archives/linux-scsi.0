From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: One question about SCSI device hotplug
Date: Tue, 1 Mar 2005 14:46:04 +0000
Message-ID: <20050301144604.GJ28741@parcelfarce.linux.theplanet.co.uk>
References: <8126E4F969BA254AB43EA03C59F44E840184FB09@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:1427 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261929AbVCAOqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 09:46:05 -0500
Content-Disposition: inline
In-Reply-To: <8126E4F969BA254AB43EA03C59F44E840184FB09@pdsmsx404>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhao, Forrest" <forrest.zhao@intel.com>
Cc: linux-scsi@vger.kernel.org, "Caushik, Ramesh" <ramesh.caushik@intel.com>

On Tue, Mar 01, 2005 at 05:06:55PM +0800, Zhao, Forrest wrote:
> If I surprisingly hot-remove a SCSI disk from HBA manually 
> without executing "echo "scsi remove-single-device
>  <h> <b> <t <l>" > /proc/scsi/scsi", can the "hotplug"
> event be notified to SCSI mid-layer or user space?
> 
> I briefly browse some code of LLDD, it seems that LLDD never
> report "hotplug" event to upper-level layer. Am I right?

I don't think it *can* ... the SCSI protocols don't tell the host "hey,
this device has disappeared".

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
