From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Reading data from a file
Date: Tue, 31 Dec 2002 14:43:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF45C02259.616AE3AA-ON87256CA0.007C7138-88256CA0.007CED51@us.ibm.com>
References: <20021227153427.70720.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021227153427.70720.qmail@mail.com>
List-Id: linux-scsi@vger.kernel.org
To: David Anderson <david-ander2023@mail.com>
Cc: linux-scsi@vger.kernel.org

>I am reading some data from a file byte by byte in my driver.

In what way is is byte by byte?  You're calling some subroutine once for 
each byte?

The most obvious way to read a file is not in any way byte by byte, so I 
don't understand the problem.

>Any suggestions on how I can improve ??

Can you be more specific on the improvement you're looking for?

