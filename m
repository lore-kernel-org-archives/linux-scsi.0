From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Consult]: Can the coming Huawei scsi device handler be accepted
 in the scsi/device_handler
Date: Sun, 14 May 2017 22:34:18 -0700
Message-ID: <20170515053418.GA17024@infradead.org>
References: <a708085e-e9f0-3b5f-0290-00db8071a6b2@huawei.com>
 <70bd5fb5-a612-53d3-cc39-92ade30de9c0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43895 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758532AbdEOFe3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 01:34:29 -0400
Content-Disposition: inline
In-Reply-To: <70bd5fb5-a612-53d3-cc39-92ade30de9c0@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guan Junxiong <guanjunxiong@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, agk@redhat.com, snitzer@redhat.com, "Hege (A)" <hege09@huawei.com>, shenhong09@huawei.com, Yang Feng <philip.yang@huawei.com>, "Zouming (IT)" <zouming.zouming@huawei.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Mon, May 15, 2017 at 12:08:12PM +0800, Guan Junxiong wrote:
> Hi, Christoph Hellwig
>   Thanks for your reply. But I am  a little confused:
> 
>   Our Huawei scsi device handler will support ALUA. Besides , some new enhancements such as error self negotiation
> on the scsi (maybe NMVe in the future) error status handling to enhance reliability.  Here are two choices:
>    1) Alter the scsi_dh_alua.c directly and make a generic way to handle error status.
>    2) Add a new file named scsi_dh_huawei.c which implements the ALUA feature and error negotiation feature.
> 
>    Can those two choices be accepted by linux-scsi?

The choice is 

 (3) get your enhancements standardized in T10 and NVMe.
