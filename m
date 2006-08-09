From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Support attaching SATA devices
Date: Wed, 09 Aug 2006 10:27:07 -0500
Message-ID: <44D9FECB.3080004@us.ibm.com>
References: <200608091522.k79FMON6004111@d01av01.pok.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200608091522.k79FMON6004111@d01av01.pok.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James,

This patch depends on the SAS libata API that was just recently
added to Jeff's #upstream branch. Should I resend this patch once
the libata changes are upstream?


Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
