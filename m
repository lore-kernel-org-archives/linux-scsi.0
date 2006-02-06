From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/15] libata: support SATA devices on SAS HBAs
Date: Mon, 06 Feb 2006 09:42:08 -0600
Message-ID: <43E76E50.3040509@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The following patch enhances libata to allow SAS device drivers
to utilize libata to talk to SATA devices.

It is against libata-dev.git#upstream.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
