From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: ide-scsi data transfer residuals
Date: Mon, 8 Jul 2002 15:33:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000201c226b6$613a76c0$e0019d89@cybernetics.com>
References: <3D265179.BB1444E1@torque.net>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D265179.BB1444E1@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> However here is the calculation it should do:
>   Scsi_Cmnd::resid = Scsi_Cmnd::bufflen - <actual_bytes_transferred>

Thanks.  With this info it was easy enough to figure out the rest.

Anthony J. Battersby
Cybernetics

