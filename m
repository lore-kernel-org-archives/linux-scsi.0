From: Jeff Garzik <jeff@garzik.org>
Subject: Re: slave_configure for qlogicpti
Date: Sun, 30 Sep 2007 20:52:45 -0400
Message-ID: <470044DD.40100@garzik.org>
References: <20070919124637.GE7624@parisc-linux.org> <20070930.172952.85384131.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070930.172952.85384131.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

David Miller wrote:
> It compiles :-)  You deleted the only uses of scsi_rbuf_{get,put}()
> so you can kill those off too.


Seeing as how they are exact duplicates of libata's 
ata_scsi_rbuf_{get,put}, I wonder how they got there in the first place 
(rather than becoming common code), and I wonder how many more copies 
are floating out there...

	Jeff


