From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 2/3] scsi_dh: Change scsi device handler modules to
	utilize modalias
Date: Wed, 18 Mar 2009 09:46:29 -0400
Message-ID: <20090318134629.GB19448@mars.virtualiron.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu> <20090318013627.26548.27704.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:42306
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754668AbZCRNr2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 09:47:28 -0400
Content-Disposition: inline
In-Reply-To: <20090318013627.26548.27704.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

.. snip..
> +	{TYPE_ANY, "HP", "HSV300" },
> +	{TYPE_ANY, "IBM", "2107900" },
> +	{TYPE_ANY, "IBM", "2145" },
> +	{TYPE_ANY, "Pillar", "Axiom" },
> +	{0, "", ""},

Is there a define for '0' value?
