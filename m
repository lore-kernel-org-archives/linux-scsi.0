From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: When must the io_request_lock be held?
Date: Mon, 5 Aug 2002 19:53:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020805195325.B19398@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from jamesw@localhost)
	by wintermute.ma.emulex.com (8.11.6/8.11.6) id g75NrPw19513
	for linux-scsi@vger.kernel.org; Mon, 5 Aug 2002 19:53:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When does a low-level driver have to hold the io_request_lock?  I know
that a driver should take the lock when it calls a SCSI command's done
function.  Also, when the driver's queuecommand is entered, it already
holds this lock.

I've seen some drivers that drop the lock (via either spin_unlock or
spin_unlock_irq) inside their queuecommand.  What are the rules for
dropping (and reacquiring) the lock here?

Thanks,
Jamie Wellnitz
