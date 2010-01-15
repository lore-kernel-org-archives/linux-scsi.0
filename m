From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-mpath: Two minor fixes while processing
	activate_path
Date: Fri, 15 Jan 2010 17:57:08 +0000
Message-ID: <20100115175708.GE17760@agk-dp.fab.redhat.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4877BC98C@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0AOR5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2010 12:57:15 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0FHvFMA010964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2010 12:57:15 -0500
Content-Disposition: inline
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4877BC98C@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 05, 2010 at 03:43:44PM -0700, Moger, Babu wrote:
> -		DMERR("Cannot failover device because scsi_dh_%s was not "
> -		      "loaded.", m->hw_handler_name);
> +		DMERR("Could not failover device. Error %d.", errors);

Would it be meaningful still to include m->hw_handler_name in that message?

Alasdair

