From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Adaptec 9405w in debian - HELP
Date: Mon, 24 Jul 2006 15:30:17 -0700
Message-ID: <20060724223017.GA11296@us.ibm.com>
References: <20060723141934.GA12721@beraldoleal.org> <20060724140708.046490ba.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:10914 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932299AbWGXWaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 18:30:14 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6OMUEPA005417
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 18:30:14 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6OMUERj280206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 18:30:14 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6OMUDrS028615
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 18:30:13 -0400
Content-Disposition: inline
In-Reply-To: <20060724140708.046490ba.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Beraldo Leal <uid0@beraldoleal.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Andrew Morton <akpm@osdl.org> wrote:
> 
> > Hi Andrew, I see your page in wikipedia about the Adaptec 9405w, I
> > follow the steps, but I don't see my SATA disk.

The version of the aic94xx driver in James aic94xx-sas-2.6 git tree, which
I assume the patch previously mentioned is derived from, does not contain
SATA support. Currently it is only supporting SAS.

-andmike
--
Michael Anderson
andmike@us.ibm.com
