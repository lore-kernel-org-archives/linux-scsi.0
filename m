From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: Fwd: 32bit dev_t
Date: Fri, 24 Jan 2003 10:29:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124182952.GF20972@ca-server1.us.oracle.com>
References: <3E2DC21D.9010204@torque.net> <20030123183131.GA2126@nbkurt.garloff.de> <20030123221805.A2468@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-mail2.oracle.com (localhost [127.0.0.1])
	by inet-mail2.oracle.com (Switch-2.2.3/Switch-2.2.3) with ESMTP id h0OIU2n26027
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2003 10:30:02 -0800 (PST)
Received: from rgmgw6.us.oracle.com (rgmgw6.us.oracle.com [138.1.191.15])
	by inet-mail2.oracle.com (Switch-2.2.3/Switch-2.2.3) with ESMTP id h0OIU2a25896
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2003 10:30:02 -0800 (PST)
Received: from rgmgw6.us.oracle.com (localhost [127.0.0.1])
	by rgmgw6.us.oracle.com (Switch-2.1.3/Switch-2.1.0) with ESMTP id h0OIU1w23784
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2003 11:30:01 -0700 (MST)
Content-Disposition: inline
In-Reply-To: <20030123221805.A2468@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kurt Garloff <kurt@garloff.de>, Douglas Gilbert <dougg@torque.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 10:18:05PM +0000, Christoph Hellwig wrote:
> the Linux 2.5 sd and sr drivers are only limited by the number of majors
> allocated to them.  There's no more architectural limit or any global
> array.

	How are they allocated?  Is this dynamic, or compiled in?  In
addition, what is the maximum amount?  If it's less than 1000 disks,
it's too small for today.  If it's less than 2000 disks, it's probably
too small for 2.6's lifetime.

Joel


-- 

 "Practice random acts of kindness and senseless acts of beauty."

 Oh, and don't forget where your towel is.

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
