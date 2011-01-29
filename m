From: James Bottomley <James.Bottomley@suse.de>
Subject: [LSF/MM ATTEND] discussion around bettter SAS/SATA integration
Date: Sat, 29 Jan 2011 09:53:39 -0800
Message-ID: <1296323619.3020.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: lsf10-pc@lists.linuxfoundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I'm not sure it will be a whole topic (or rather I suspect others want
to present on this), but I'd like to discuss better SAS/SATA
integration.  Right at the moment, I think we're getting close to
agreement on how to integrate the new error handler into libsas ...
we're still further off on the other consumer: ipr.  However, trying to
integrate libsas into the libata transport class hierarchy is proving
challenging (read it keep crashing), so I'd like to spend some time with
the interested parties trying to make all this work.

James


