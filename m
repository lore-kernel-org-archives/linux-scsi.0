From: Tim Small <tim@seoss.co.uk>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Thu, 27 Nov 2014 07:08:13 +0000
Message-ID: <5476CDDD.3040501@seoss.co.uk>
References: <20141121100210.GC8866@infradead.org> <1416924562-16849-1-git-send-email-tim@seoss.co.uk> <20141125162620.GA31478@infradead.org> <5474AE9B.40104@fb.com> <5475F2DD.9030906@seoss.co.uk> <CAGRGNgWCdbqTjbBu9fbwWHe9AHK04vO_5HAwyo4rH80PyUQKbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:38089 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbaK0HI4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2014 02:08:56 -0500
In-Reply-To: <CAGRGNgWCdbqTjbBu9fbwWHe9AHK04vO_5HAwyo4rH80PyUQKbA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, tim@buttersideup.com, Wakko Warner <wakko@animx.eu.org>

On 26/11/14 23:01, Julian Calaby wrote:
> As you're playing with locks, I assume you're running with LOCKDEP
> enabled? If not, that might tell you what's going on.

Hi,

Sorry - I should have said - LOCKDEP is on, and not reporting anything...

Cheers,

Tim.

