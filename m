From: "Vitezslav Samel" <samel@mail.cz>
Subject: [BUG] problems with USB memory pen
Date: Fri, 10 Oct 2003 08:03:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031010060350.GA5962@pc11.op.pod.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

	Hi!

  Since 2.6.0-test6 ther is an annoying problem with my USB memory pen.
First time I insert it, kernel gives it "sdc" (which is O.K.). Next time
kernel gives it "sdd", "sde" and so on. Seems like someone is not releasing
unused SCSI devices.

  I narrowed down this problem to linux-2.6.0-test5-bk14. There are no USB
changes, but are SCSI changes which I don't understand that well to fix my
problem.

  I would appreciate if someone will look at it.

	Thanks,
		Vita Samel
