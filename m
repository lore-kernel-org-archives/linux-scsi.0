From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 12:46:34 +0100
Message-ID: <20060829114634.GE4076@infradead.org>
References: <44EFBEFA.2010707@student.ltu.se> <20060828093202.GC8980@infradead.org> <20060828171804.09c01846.akpm@osdl.org> <44F3952B.5000500@yahoo.com.au> <1156836578.26009.6.camel@imp.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50617 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964958AbWH2LrG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 07:47:06 -0400
Content-Disposition: inline
In-Reply-To: <1156836578.26009.6.camel@imp.csi.cam.ac.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>, Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 29, 2006 at 08:29:38AM +0100, Anton Altaparmakov wrote:
> Not sure whether this is meant in favour of one or the other but we are
> not programming in C strictly speaking but in C99+gccisms and C99
> includes _Bool...

as does it include float, double, _Complex and other things we don't use.

