From: Tim Pepper <tpepper@gmail.com>
Subject: Re: [dm-devel] Re: fastfail operation and retries
Date: Mon, 25 Apr 2005 16:56:56 -0700
Message-ID: <eada2a070504251656762a8625@mail.gmail.com>
References: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
	 <20050421222409.GY17315@marowsky-bree.de>
	 <ac71172a050422121365a32cc3@mail.gmail.com>
Reply-To: Tim Pepper <tpepper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.196]:39581 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261177AbVDYX44 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2005 19:56:56 -0400
Received: by wproxy.gmail.com with SMTP id 68so1988225wra
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2005 16:56:56 -0700 (PDT)
In-Reply-To: <ac71172a050422121365a32cc3@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tranlan@us.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>, Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com

On 4/22/05, Lan <transter@gmail.com> wrote:
>
> queue_if_no_path must be used; I'm not sure why any dm-multipath
> storage users would not want to turn on queue_if_no_path by default?

What protection is there against long term queueing and running the
machine out of memory?
