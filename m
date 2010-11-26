From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: remove unused snapshot attributes
Date: Thu, 25 Nov 2010 17:40:32 -0800
Message-ID: <1290735632.16160.4.camel@haakon2.linux-iscsi.org>
References: <20101125080116.GB6469@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53777 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0KZBqD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2010 20:46:03 -0500
In-Reply-To: <20101125080116.GB6469@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-11-25 at 03:01 -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Ok, I don't have an issue with dropping these snapshot attributes..
Committed as c11113792 with the following message:

"This patch drops /sys/kernel/config/target/core/$HBA/$DEV/snap/ which
 was originally used by lio-utils.git/tcm-py/tcm_snap.py as a simple
 method of rolling LVM COW snapshots."

--nab


