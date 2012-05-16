From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC V1 0/4] Add support for pci/non-pci probing for UFS
Date: Wed, 16 May 2012 08:16:31 -0400
Message-ID: <20120516121631.GA25085@infradead.org>
References: <1337083436-4204-1-git-send-email-girish.shivananjappa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44868
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759941Ab2EPMQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 08:16:33 -0400
Content-Disposition: inline
In-Reply-To: <1337083436-4204-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

Please redo the patch series as:

 patch 1: split pci into a separate module, including removing the old
          code, adding the new code and all the kconfig wire up
 patch 2: add platform probing

so that the tree always stays in a working state.
