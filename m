From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.01 released
Date: Sun, 18 Aug 2002 19:46:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6031CA.C4070B85@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Martin Schwenke <martin@meltin.net>

This minor release of sg3_utils adds a raw switch to
the sg_inq command. To aid programmatic decoding of
its output, all informative and error messages are sent
to stderr while the data (ASCII, ASCII-HEX or binary) is
sent to stdout. [BTW sg_dd and friends do the same thing.]

This update is based on work by Martin Schwenke.

The http://www.torque.net/sg page has been updated
and I have sent a release note to freshmeat.net .

Doug Gilbert
