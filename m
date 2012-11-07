From: Andy Grover <agrover@redhat.com>
Subject: scsi target, likely GPL violation
Date: Wed, 07 Nov 2012 08:50:35 -0800
Message-ID: <509A915B.30105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>, Nicholas Bellinger <nab@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

Nick,

Your company appears to be shipping kernel features in RTS OS that are
not made available under the GPL, specifically support for the
EXTENDED_COPY and COMPARE_AND_WRITE SCSI commands, in order to claim
full Vmware vSphere 5 VAAI support.

http://www.risingtidesystems.com/storage.html
http://www.linux-iscsi.org/wiki/VAAI

Private emails to you and RTS CEO Marc Fleischmann have not elicited a
useful response.

You are subsystem maintainer for the in-kernel SCSI target support
(drivers/target/*), and your company appears to be violating the GPL.
Please explain.

Regards -- Andy
