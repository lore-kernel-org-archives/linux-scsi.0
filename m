From: Tom Coughlan <coughlan@redhat.com>
Subject: Re: [PATCH][RFC] Driverfs support for SCSI devices (updated)
Date: Wed, 19 Jun 2002 10:13:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D1091A6.D6E5A9EB@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: sullivan@austin.ibm.com, linux-scsi@vger.kernel.org

Hello Mike,

Just one point on your scanning of Inquiry page 83.  As you know,
the page may contain many Identifiers.  Each Identifier has an
Association field.  This field indicates whether the Identifier is
associated with the logical unit, or with a port that is used to
access the logical unit.  You should only use an identifier that is
associated with the logical unit.

I don't think may vendors are putting port identifiers in Page 83,
so this may not be a big deal, but I'm worried that if they do, the
FC port IDs will show up as Type 3 Identifiers, and we will
incorrectly select a port ID instead of the Logical Unit ID.

Thanks.

-- 
Tom Coughlan
Red Hat
978-692-3113 ext. 23209
