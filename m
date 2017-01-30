From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 21/24] aacraid: Retrieve HBA host information ioctl
Date: Mon, 30 Jan 2017 12:43:14 +0100
Message-ID: <20170130114314.GP3603@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-22-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbdA3LnS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 06:43:18 -0500
Content-Disposition: inline
In-Reply-To: <20170127192853.10082-22-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Fri, Jan 27, 2017 at 11:28:50AM -0800, Raghava Aditya Renukunta wrote:
> Added a new ioctl interface to retrieve the host device information.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

[...]

> + * This is for management ioctl purpose only.
> + */
> +struct aac_hba_info {
> +
> +	u8	DriverName[50];
> +	u8	AdapterNumber;
> +	u8	SystemIoBusNumber;
> +	u8	DeviceNumber;
> +	u32	FunctionNumber;
> +	u32	VendorID;
> +	u32	DeviceID;
> +	u32	SubVendorID;
> +	u32	SubSystemID;
> +	u32	MappedBaseAddressSize;
> +	u32	BasePhysicalAddress_HighPart;
> +	u32	BasePhysicalAddress_LowPart;
> +
> +	u32	MaxCommandSize;
> +	u32	MaxFibSize;
> +	u32	MaxScatterGatherFromOs;
> +	u32	MaxScatterGatherToFw;
> +	u32	MaxOutstandingFibs;
> +
> +	u32	QueueStartThreshold;
> +	u32	QueueDumpThreshold;
> +	u32	MaxIoSizeQueued;
> +	u32	OutstandingIO;
> +
> +	u32	FirmwareBuildNumber;
> +	u32	BIOSBuildNumber;
> +	u32	DriverBuildNumber;
> +	u32	SerialNumber_HighPart;
> +	u32	SerialNumber_LowPart;
> +	u32	SupportedOptions;
> +	u32	FeatureBits;
> +	u32	currentnumberPorts;
> +
> +	u8	NewCommInterface:1;
> +	u8	NewCommandsSupported:1;
> +	u8	DisablePassthrough:1;
> +	u8	ExposeNonDasd:1;
> +	u8	QueueAllowed:1;
> +	u8	BLEDCheckEnabled:1;
> +	u8	reserved1:1;
> +	u8	reserted2:1;
> +
> +	u32	reserved3[10];
> +
> +};

Again, is it possible to get this without CamelCase?

Anyways,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
