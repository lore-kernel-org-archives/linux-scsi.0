From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 17:53:22 +0200
Message-ID: <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:59777 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965380AbYEBPxY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:53:24 -0400
Received: by fg-out-1718.google.com with SMTP id 19so974848fgg.17
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2008 08:53:22 -0700 (PDT)
In-Reply-To: <20080502153306.GB7376@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, May 2, 2008 at 5:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> NACK.
>
> First scsi_execute_async has a horrible API and thus it's on it's way
> out, no way we'll add another variant of it.
>
> Second we're not going to add things to the core just for out of tree
> modules.

Regarding out-of-tree modules: this is just a preparatory step before
submitting SCST for inclusion in the mainstream kernel.

Regarding scsi_execute_async(): I didn't know that this API is on its
way out. What will it be replaced by, and when ?

Bart.
