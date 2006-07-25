From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Adaptec 9405w in debian - HELP
Date: Mon, 24 Jul 2006 17:15:11 -0700
Message-ID: <20060725001511.GA13050@us.ibm.com>
References: <20060723141934.GA12721@beraldoleal.org> <20060724140708.046490ba.akpm@osdl.org> <20060724223017.GA11296@us.ibm.com> <20060724220320.GA28204@beraldoleal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:6275 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S932349AbWGYAPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 20:15:10 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6P0F8Y8029445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 20:15:08 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6P0F7xf163024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 18:15:07 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6P0F7A1016582
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 18:15:07 -0600
Content-Disposition: inline
In-Reply-To: <20060724220320.GA28204@beraldoleal.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Beraldo Leal <uid0@beraldoleal.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Beraldo Leal <uid0@beraldoleal.org> wrote:
> Thanks for all. I will find about SAS, because I tell for support IBM
> and them say-me with the Adaptec SATA 9405w work in Red Hat, them I
> lookup arround internet, about Debian, but if you say-me with this not
> work with SATA. Ok no problem!:)

SATA working in RedHat was most likely using the adp94xx driver.

-andmike
--
Michael Anderson
andmike@us.ibm.com
