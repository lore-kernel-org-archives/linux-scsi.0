From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 08 Apr 2002 13:28:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204081828.g38ISgp04833@localhost.localdomain>
References: <mjacob@feral.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA05883
	for <linux-scsi@vger.kernel.org>; Mon, 8 Apr 2002 11:28:45 -0700
In-Reply-To: Message from Matthew Jacob <mjacob@feral.com>
   of "Mon, 08 Apr 2002 11:18:55 PDT." <Pine.BSF.4.21.0204081118320.46879-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

mjacob@feral.com said:
> Then let's use WWPN/WWNS and/or drive serial #'s to do UUIDs for
> devices. 

That's what the persistent binding proposal that started all this uses.  
However, these strings are incredibly long at best and (in spite of what the 
SCSI spec says) sometimes include non-printing characters, so you don't 
necessarily want to be passing them on the command line.

James



