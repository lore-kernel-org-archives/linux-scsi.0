From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: ide-scsi data transfer residuals
Date: Fri, 5 Jul 2002 10:07:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ag4973$k4k$2@main.gmane.org>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Hello,

I am using the scsi-generic and ide-scsi drivers together for low-level
access to an IDE tape drive (vanilla 2.4.17).  I noticed that the data
transfer residual in sg_io_hdr_t { int resid; } is always zero.  I assume
that the residual calculation is just a missing feature from the ide-scsi
driver.  Does anyone know how hard it is to add it?

Please CC me in any replies.

Thanks,
Anthony J. Battersby
Cybernetics

