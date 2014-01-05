From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: eliminate scsi_transport_srp.c kernel-doc warnings
Date: Sat, 04 Jan 2014 17:53:53 -0800
Message-ID: <52C8BB31.7020709@infradead.org>
References: <52C0FE81.4080209@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37826 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaAEBx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jan 2014 20:53:57 -0500
In-Reply-To: <52C0FE81.4080209@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: dgilbert@interlog.com

From: Randy Dunlap <rdunlap@infradead.org>

drivers/scsi/scsi_transport_srp.c has incomplete kernel-doc notation
for some of the functions. This causes several kernel-doc warnings.

Fix these kernel-doc warnings by changing the beginning /** kernel-doc
marker to a plain /* comment.

Warning(drivers/scsi/scsi_transport_srp.c:75): No description found for parameter 'reconnect_delay'
Warning(drivers/scsi/scsi_transport_srp.c:75): No description found for parameter 'fast_io_fail_tmo'
Warning(drivers/scsi/scsi_transport_srp.c:75): No description found for parameter 'dev_loss_tmo'
Warning(drivers/scsi/scsi_transport_srp.c:373): No description found for parameter 'work'
Warning(drivers/scsi/scsi_transport_srp.c:413): No description found for parameter 'work'
Warning(drivers/scsi/scsi_transport_srp.c:431): No description found for parameter 'work'
Warning(drivers/scsi/scsi_transport_srp.c:496): No description found for parameter 'rport'
Warning(drivers/scsi/scsi_transport_srp.c:507): No description found for parameter 'shost'
Warning(drivers/scsi/scsi_transport_srp.c:545): No description found for parameter 'rport'
Warning(drivers/scsi/scsi_transport_srp.c:611): No description found for parameter 'scmd'
Warning(drivers/scsi/scsi_transport_srp.c:679): No description found for parameter 'rport'
Warning(drivers/scsi/scsi_transport_srp.c:688): No description found for parameter 'rport'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/scsi/scsi_transport_srp.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- lnx-313-rc7.orig/drivers/scsi/scsi_transport_srp.c
+++ lnx-313-rc7/drivers/scsi/scsi_transport_srp.c
@@ -62,7 +62,7 @@ static inline struct Scsi_Host *rport_to
 	return dev_to_shost(r->dev.parent);
 }
 
-/**
+/*
  * srp_tmo_valid() - check timeout combination validity
  *
  * The combination of the timeout parameters must be such that SCSI commands
@@ -366,7 +366,7 @@ invalid:
 	return -EINVAL;
 }
 
-/**
+/*
  * srp_reconnect_work() - reconnect and schedule a new attempt if necessary
  */
 static void srp_reconnect_work(struct work_struct *work)
@@ -406,7 +406,7 @@ static void __rport_fail_io_fast(struct
 		i->f->terminate_rport_io(rport);
 }
 
-/**
+/*
  * rport_fast_io_fail_timedout() - fast I/O failure timeout handler
  */
 static void rport_fast_io_fail_timedout(struct work_struct *work)
@@ -424,7 +424,7 @@ static void rport_fast_io_fail_timedout(
 	mutex_unlock(&rport->mutex);
 }
 
-/**
+/*
  * rport_dev_loss_timedout() - device loss timeout handler
  */
 static void rport_dev_loss_timedout(struct work_struct *work)
@@ -486,7 +486,7 @@ static void __srp_start_tl_fail_timers(s
 	}
 }
 
-/**
+/*
  * srp_start_tl_fail_timers() - start the transport layer failure timers
  *
  * Start the transport layer fast I/O failure and device loss timers. Do not
@@ -500,7 +500,7 @@ void srp_start_tl_fail_timers(struct srp
 }
 EXPORT_SYMBOL(srp_start_tl_fail_timers);
 
-/**
+/*
  * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
  */
 static int scsi_request_fn_active(struct Scsi_Host *shost)
@@ -520,7 +520,7 @@ static int scsi_request_fn_active(struct
 	return request_fn_active;
 }
 
-/**
+/*
  * srp_reconnect_rport() - reconnect to an SRP target port
  *
  * Blocks SCSI command queueing before invoking reconnect() such that
@@ -597,7 +597,7 @@ out:
 }
 EXPORT_SYMBOL(srp_reconnect_rport);
 
-/**
+/*
  * srp_timed_out() - SRP transport intercept of the SCSI timeout EH
  *
  * If a timeout occurs while an rport is in the blocked state, ask the SCSI
@@ -672,7 +672,7 @@ static int srp_host_match(struct attribu
 	return &i->t.host_attrs.ac == cont;
 }
 
-/**
+/*
  * srp_rport_get() - increment rport reference count
  */
 void srp_rport_get(struct srp_rport *rport)
@@ -681,7 +681,7 @@ void srp_rport_get(struct srp_rport *rpo
 }
 EXPORT_SYMBOL(srp_rport_get);
 
-/**
+/*
  * srp_rport_put() - decrement rport reference count
  */
 void srp_rport_put(struct srp_rport *rport)
