From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/3] BusLogic: Message logging neatening
Date: Thu, 16 May 2013 21:58:29 -0700
Message-ID: <cover.1368765873.git.joe@perches.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1368754556.git.khalid.aziz@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If you're going through the trouble to fix this CamelCase stuff
and make it work on 64 bit, how about a little more cleanup?

Joe Perches (3):
  BusLogic: Add __printf verification, fix fallout
  BusLogic: Coalesce formats with multiple string fragments
  BusLogic: Use more conventional argument order for logging

 drivers/scsi/BusLogic.c | 304 ++++++++++++++++++++++++------------------------
 drivers/scsi/BusLogic.h |  23 ++--
 2 files changed, 161 insertions(+), 166 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty
