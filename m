From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [PATCH 1/3] qla1280: remove qla1280_proc_info
Date: 18 Feb 2005 04:46:35 -0500
Message-ID: <yq07jl6nqtg.fsf@jaguar.mkp.net>
References: <20050210155952.GA8743@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from vanessarodrigues.com ([192.139.46.150]:55249 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S261317AbVBRJqg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 04:46:36 -0500
In-Reply-To: <20050210155952.GA8743@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> reading the /proc/scsi/qla1280/* files can easily corrupt
Christoph> kernel memory.  As the feature is deprecated, and the
Christoph> qla1280 implementation doesn't return very usefull
Christoph> implementation but is so buggy that any serious user would
Christoph> have noticed we just remove it.

No objections here, /proc thing has been known to be broken for ages
and I have seen few complaints over it.

Jes
