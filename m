From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Thu, 24 Oct 2002 19:20:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021024232026.GF17575@linnie.riede.org>
References: <dledford@redhat.com> <200210231416.g9NEGoI01976@localhost.localdomain> <20021023171335.B17312@lst.de>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id g9ONKQC20541
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2002 19:20:26 -0400
Content-Disposition: inline
In-Reply-To: <20021023171335.B17312@lst.de>; from hch@lst.de on Wed, Oct 23, 2002 at 11:13:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2002.10.23 11:13 Christoph Hellwig wrote:
> 
> Well, I'm working on removing ->init.  With the patch posted yersterday
> only sg.c and osst.c are left implementing it.
> 
Ermm, osst (which I maintain) works the same as st in this respect.
I didn't notice any changes to st.c in that patch. What am I missing?

Thanks, Willem Riede.
