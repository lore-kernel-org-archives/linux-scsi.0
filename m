From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: add some internal zfcp adapter statistics
Date: Sat, 3 Nov 2007 10:40:58 +0100
Message-ID: <20071103094058.GA25134@osiris.boeblingen.de.ibm.com>
References: <200710311133.52090.swen@vnet.ibm.com> <20071103091722.GA7807@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:26522 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbXKCJlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Nov 2007 05:41:31 -0400
Content-Disposition: inline
In-Reply-To: <20071103091722.GA7807@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, Linux on 390 Port <LINUX-390@vm.marist.edu>, linux-kernel <linux-kernel@vger.kernel.org>

> > +	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)) {
> > +		ZFCP_LOG_NORMAL("error: Enhanced measurement feature not "
> > +				"supported");
> > +		return -EOPNOTSUPP;
> > +	}

Btw. any user can flood the console with these messages if the adapter
doesn't support the feature. That can be considered a denial of service
attack. Please just return -EOPNOTSUPP and don't print anything on the
console.
