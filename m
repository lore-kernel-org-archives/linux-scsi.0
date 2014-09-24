From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] hpsa: add missing pci_set_master in kdump path
Date: Wed, 24 Sep 2014 06:54:50 -0700
Message-ID: <20140924135450.GA16067@infradead.org>
References: <5412EA9F.4060703@redhat.com>
 <54229D86.4050205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaIXNyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 09:54:51 -0400
Content-Disposition: inline
In-Reply-To: <54229D86.4050205@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, elliott@hp.com, steve.cameron@hp.com, "Handzik, Joe" <joseph.t.handzik@hp.com>, Webb Scales <webbnh@hp.com>

Robert or Webb: can you give me a review on this?  Given that Robert
helped finding it that should be easy..

