From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [scsi] enclosure: remove all possible sysfs entries
 before add device
Date: Mon, 9 Sep 2013 06:41:31 -0700
Message-ID: <20130909134131.GB24738@infradead.org>
References: <522D685D.5060201@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <522D685D.5060201@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Jin <joe.jin@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Modules linked in: oracleacfs(P)(U) oracleadvm(P)(U) oracleoks(P)(U)

Please reproduce without this weird crap loaded.
