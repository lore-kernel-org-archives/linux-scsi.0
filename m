From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] be2iscsi: Adding a shutdown Routine
Date: Tue, 23 Aug 2011 16:20:21 -0500
Message-ID: <4E541995.5070408@cs.wisc.edu>
References: <1314032910-2304-1-git-send-email-jayamohan.kallickal@emulex.com> <1aea287b-60e9-4ae7-95f8-fdbdc272d622@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42172 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1HWVQ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2011 17:16:27 -0400
In-Reply-To: <1aea287b-60e9-4ae7-95f8-fdbdc272d622@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>
Cc: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org

On 08/22/2011 12:08 PM, Jayamohan Kallickal wrote:
> +static void beiscsi_remove(struct pci_dev *pcidev)
> +{
> +
> +	struct beiscsi_hba *phba = NULL;
> +
> +	phba = pci_get_drvdata(pcidev);


> +static void beiscsi_shutdown(struct pci_dev *pcidev)
> +{
> +
> +	struct beiscsi_hba *phba = NULL;
> +
> +	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);


No need for casting.
