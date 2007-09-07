From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 1/2] zfcp: whitespace cleanup
Date: Fri, 7 Sep 2007 09:15:31 +0200
Message-ID: <200709070915.31492.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:29317 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859AbXIGHQR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2007 03:16:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com

From: Swen Schillig <swen@vnet.ibm.com>

Cleanup the whitepace from the entire zfcp driver to prevent
to have those changes in future feature or function patches.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c        |    4 -
 drivers/s390/scsi/zfcp_def.h        |   46 ++++++------
 drivers/s390/scsi/zfcp_erp.c        |  134 ++++++++++++++++++------------------
 drivers/s390/scsi/zfcp_ext.h        |   30 ++++----
 drivers/s390/scsi/zfcp_fsf.c        |   40 +++++-----
 drivers/s390/scsi/zfcp_fsf.h        |   30 ++++----
 drivers/s390/scsi/zfcp_qdio.c       |    7 -
 drivers/s390/scsi/zfcp_scsi.c       |   36 ++++-----
 drivers/s390/scsi/zfcp_sysfs_unit.c |    4 -
 9 files changed, 165 insertions(+), 166 deletions(-)

Index: HEAD/drivers/s390/scsi/zfcp_aux.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_aux.c
+++ HEAD/drivers/s390/scsi/zfcp_aux.c
@@ -891,7 +891,7 @@ zfcp_unit_dequeue(struct zfcp_unit *unit
 /*
  * Allocates a combined QTCB/fsf_req buffer for erp actions and fcp/SCSI
  * commands.
- * It also genrates fcp-nameserver request/response buffer and unsolicited 
+ * It also genrates fcp-nameserver request/response buffer and unsolicited
  * status read fsf_req buffers.
  *
  * locks:       must only be called with zfcp_data.config_sema taken
@@ -982,7 +982,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 	struct zfcp_adapter *adapter;
 
 	/*
-	 * Note: It is safe to release the list_lock, as any list changes 
+	 * Note: It is safe to release the list_lock, as any list changes
 	 * are protected by the config_sema, which must be held to get here
 	 */
 
Index: HEAD/drivers/s390/scsi/zfcp_def.h
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_def.h
+++ HEAD/drivers/s390/scsi/zfcp_def.h
@@ -1,23 +1,23 @@
-/* 
+/*
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
  * (C) Copyright IBM Corp. 2002, 2006
- * 
- * This program is free software; you can redistribute it and/or modify 
- * it under the terms of the GNU General Public License as published by 
- * the Free Software Foundation; either version 2, or (at your option) 
- * any later version. 
- * 
- * This program is distributed in the hope that it will be useful, 
- * but WITHOUT ANY WARRANTY; without even the implied warranty of 
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
- * GNU General Public License for more details. 
- * 
- * You should have received a copy of the GNU General Public License 
- * along with this program; if not, write to the Free Software 
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
- */ 
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #ifndef ZFCP_DEF_H
 #define ZFCP_DEF_H
@@ -90,7 +90,7 @@ zfcp_address_to_sg(void *address, struct
 #define ZFCP_DEVICE_TYPE        0x1732
 #define ZFCP_DEVICE_MODEL       0x03
 #define ZFCP_DEVICE_MODEL_PRIV	0x04
- 
+
 /* allow as many chained SBALs as are supported by hardware */
 #define ZFCP_MAX_SBALS_PER_REQ		FSF_MAX_SBALS_PER_REQ
 #define ZFCP_MAX_SBALS_PER_CT_REQ	FSF_MAX_SBALS_PER_REQ
@@ -508,7 +508,7 @@ struct zfcp_rc_entry {
 
 /*
  * this allows removal of logging code by the preprocessor
- * (the most detailed log level still to be compiled in is specified, 
+ * (the most detailed log level still to be compiled in is specified,
  * higher log levels are removed)
  */
 #define ZFCP_LOG_LEVEL_LIMIT	ZFCP_LOG_LEVEL_TRACE
@@ -546,7 +546,7 @@ do { \
 	if (ZFCP_LOG_CHECK(level)) \
 		_ZFCP_LOG(fmt, ##args); \
 } while (0)
-	
+
 #if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_NORMAL
 # define ZFCP_LOG_NORMAL(fmt, args...)	do { } while (0)
 #else
@@ -583,8 +583,8 @@ do { \
 
 /*************** ADAPTER/PORT/UNIT AND FSF_REQ STATUS FLAGS ******************/
 
-/* 
- * Note, the leftmost status byte is common among adapter, port 
+/*
+ * Note, the leftmost status byte is common among adapter, port
  * and unit
  */
 #define ZFCP_COMMON_FLAGS			0xfff00000
@@ -1007,8 +1007,8 @@ struct zfcp_fsf_req {
 	u32		       fsf_command;    /* FSF Command copy */
 	struct fsf_qtcb	       *qtcb;	       /* address of associated QTCB */
 	u32		       seq_no;         /* Sequence number of request */
-        unsigned long          data;           /* private data of request */ 
-	struct timer_list      timer;	       /* used for erp or scsi er */
+	unsigned long	       data;           /* private data of request */
+	struct timer_list     timer;	       /* used for erp or scsi er */
 	struct zfcp_erp_action *erp_action;    /* used if this request is
 						  issued on behalf of erp */
 	mempool_t	       *pool;	       /* used if request was alloacted
Index: HEAD/drivers/s390/scsi/zfcp_erp.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_erp.c
+++ HEAD/drivers/s390/scsi/zfcp_erp.c
@@ -1,22 +1,22 @@
-/* 
+/*
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
  * (C) Copyright IBM Corp. 2002, 2006
- * 
- * This program is free software; you can redistribute it and/or modify 
- * it under the terms of the GNU General Public License as published by 
- * the Free Software Foundation; either version 2, or (at your option) 
- * any later version. 
- * 
- * This program is distributed in the hope that it will be useful, 
- * but WITHOUT ANY WARRANTY; without even the implied warranty of 
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
- * GNU General Public License for more details. 
- * 
- * You should have received a copy of the GNU General Public License 
- * along with this program; if not, write to the Free Software 
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_ERP
@@ -191,7 +191,7 @@ void zfcp_fsf_start_timer(struct zfcp_fs
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	called if an adapter failed,
  *		initiates adapter recovery which is done
@@ -228,7 +228,7 @@ zfcp_erp_adapter_reopen_internal(struct 
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	Wrappper for zfcp_erp_adapter_reopen_internal
  *              used to ensure the correct locking
@@ -476,7 +476,7 @@ zfcp_test_link(struct zfcp_port *port)
 
 
 /*
- * function:	
+ * function:
  *
  * purpose:	called if a port failed to be opened normally
  *		initiates Forced Reopen recovery which is done
@@ -517,7 +517,7 @@ zfcp_erp_port_forced_reopen_internal(str
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	Wrappper for zfcp_erp_port_forced_reopen_internal
  *              used to ensure the correct locking
@@ -543,7 +543,7 @@ zfcp_erp_port_forced_reopen(struct zfcp_
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	called if a port is to be opened
  *		initiates Reopen recovery which is done
@@ -612,7 +612,7 @@ zfcp_erp_port_reopen(struct zfcp_port *p
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	called if a unit is to be opened
  *		initiates Reopen recovery which is done
@@ -704,7 +704,7 @@ static void zfcp_erp_adapter_unblock(str
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	disable I/O,
  *		return any open requests and clean them up,
@@ -725,7 +725,7 @@ zfcp_erp_port_block(struct zfcp_port *po
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	enable I/O
  *
@@ -742,7 +742,7 @@ zfcp_erp_port_unblock(struct zfcp_port *
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	disable I/O,
  *		return any open requests and clean them up,
@@ -763,7 +763,7 @@ zfcp_erp_unit_block(struct zfcp_unit *un
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	enable I/O
  *
@@ -792,7 +792,7 @@ zfcp_erp_action_ready(struct zfcp_erp_ac
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:
  *
@@ -967,7 +967,7 @@ static void zfcp_erp_timeout_handler(uns
  * zfcp_erp_action_dismiss - dismiss an erp_action
  *
  * adapter->erp_lock must be held
- * 
+ *
  * Dismissal of an erp_action is usually required if an erp_action of
  * higher priority is generated.
  */
@@ -1005,9 +1005,9 @@ zfcp_erp_thread_setup(struct zfcp_adapte
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:
  *
@@ -1094,7 +1094,7 @@ zfcp_erp_thread(void *data)
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	drives single error recovery action and schedules higher and
  *		subordinate actions, if necessary
@@ -1206,7 +1206,7 @@ zfcp_erp_strategy(struct zfcp_erp_action
 
 	/*
 	 * put this target through the erp mill again if someone has
-	 * requested to change the status of a target being online 
+	 * requested to change the status of a target being online
 	 * to offline or the other way around
 	 * (old retval is preserved if nothing has to be done here)
 	 */
@@ -1228,7 +1228,7 @@ zfcp_erp_strategy(struct zfcp_erp_action
  unlock:
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-	
+
 	if (retval != ZFCP_ERP_CONTINUES)
 		zfcp_erp_action_cleanup(action, adapter, port, unit, retval);
 
@@ -1250,9 +1250,9 @@ zfcp_erp_strategy(struct zfcp_erp_action
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_DISMISSED	- if action has been dismissed
  *		retval			- otherwise
@@ -1322,7 +1322,7 @@ zfcp_erp_strategy_do_action(struct zfcp_
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	triggers retry of this action after a certain amount of time
  *		by means of timer provided by erp_action
@@ -1346,7 +1346,7 @@ zfcp_erp_strategy_memwait(struct zfcp_er
 	return retval;
 }
 
-/* 
+/*
  * function:    zfcp_erp_adapter_failed
  *
  * purpose:     sets the adapter and all underlying devices to ERP_FAILED
@@ -1362,7 +1362,7 @@ zfcp_erp_adapter_failed(struct zfcp_adap
 	debug_text_event(adapter->erp_dbf, 2, "a_afail");
 }
 
-/* 
+/*
  * function:    zfcp_erp_port_failed
  *
  * purpose:     sets the port and all underlying devices to ERP_FAILED
@@ -1386,7 +1386,7 @@ zfcp_erp_port_failed(struct zfcp_port *p
 	debug_event(port->adapter->erp_dbf, 2, &port->wwpn, sizeof (wwn_t));
 }
 
-/* 
+/*
  * function:    zfcp_erp_unit_failed
  *
  * purpose:     sets the unit to ERP_FAILED
@@ -1417,7 +1417,7 @@ zfcp_erp_unit_failed(struct zfcp_unit *u
  *              successfully is reset.
  *
  * returns:	ZFCP_ERP_CONTINUES	- action continues (not considered)
- *		ZFCP_ERP_SUCCEEDED	- action finished successfully 
+ *		ZFCP_ERP_SUCCEEDED	- action finished successfully
  *		ZFCP_ERP_EXIT		- action failed and will not continue
  */
 static int
@@ -1646,7 +1646,7 @@ zfcp_erp_schedule_work(struct zfcp_unit 
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	remaining things in good cases,
  *		escalation in bad cases
@@ -1815,7 +1815,7 @@ zfcp_erp_modify_unit_status(struct zfcp_
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	Wrappper for zfcp_erp_port_reopen_all_internal
  *              used to ensure the correct locking
@@ -1852,9 +1852,9 @@ zfcp_erp_port_reopen_all_internal(struct
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	FIXME
  */
@@ -1871,7 +1871,7 @@ zfcp_erp_unit_reopen_all_internal(struct
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	this routine executes the 'Reopen Adapter' action
  *		(the entire action is processed synchronously, since
@@ -1908,9 +1908,9 @@ zfcp_erp_adapter_strategy(struct zfcp_er
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_SUCCEEDED      - action finished successfully
  *              ZFCP_ERP_FAILED         - action finished unsuccessfully
@@ -1930,9 +1930,9 @@ zfcp_erp_adapter_strategy_close(struct z
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_SUCCEEDED      - action finished successfully
  *              ZFCP_ERP_FAILED         - action finished unsuccessfully
@@ -1957,7 +1957,7 @@ zfcp_erp_adapter_strategy_open(struct zf
  * purpose:	allocate the irq associated with this devno and register
  *		the FSF adapter with the SCSI stack
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *erp_action, int close)
@@ -2249,7 +2249,7 @@ zfcp_erp_adapter_strategy_open_fsf_statu
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	this routine executes the 'Reopen Physical Port' action
  *
@@ -2308,7 +2308,7 @@ zfcp_erp_port_forced_strategy(struct zfc
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	this routine executes the 'Reopen Port' action
  *
@@ -2530,7 +2530,7 @@ zfcp_erp_port_strategy_open_nameserver(s
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	makes the erp thread continue with reopen (physical) port
  *		actions which have been paused until the name server port
@@ -2570,9 +2570,9 @@ zfcp_erp_port_strategy_open_nameserver_w
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
  *		ZFCP_ERP_FAILED		- action finished unsuccessfully
@@ -2626,9 +2626,9 @@ zfcp_erp_port_strategy_clearstati(struct
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
  *		ZFCP_ERP_FAILED		- action finished unsuccessfully
@@ -2663,9 +2663,9 @@ zfcp_erp_port_strategy_close(struct zfcp
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
  *		ZFCP_ERP_FAILED		- action finished unsuccessfully
@@ -2700,9 +2700,9 @@ zfcp_erp_port_strategy_open_port(struct 
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
  *		ZFCP_ERP_FAILED		- action finished unsuccessfully
@@ -2737,7 +2737,7 @@ zfcp_erp_port_strategy_open_common_looku
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	this routine executes the 'Reopen Unit' action
  *		currently no retries
@@ -2825,9 +2825,9 @@ zfcp_erp_unit_strategy_clearstati(struct
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
  *		ZFCP_ERP_FAILED		- action finished unsuccessfully
@@ -2865,9 +2865,9 @@ zfcp_erp_unit_strategy_close(struct zfcp
 }
 
 /*
- * function:	
+ * function:
  *
- * purpose:	
+ * purpose:
  *
  * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
  *		ZFCP_ERP_FAILED		- action finished unsuccessfully
@@ -2913,7 +2913,7 @@ void zfcp_erp_start_timer(struct zfcp_fs
 }
 
 /*
- * function:	
+ * function:
  *
  * purpose:	enqueue the specified error recovery action, if needed
  *
@@ -2992,7 +2992,7 @@ zfcp_erp_action_enqueue(int action,
 					      port->erp_action.action);
 				debug_text_event(adapter->erp_dbf, 4,
 						 "pf_actenq_drp");
-			} else 
+			} else
 				debug_text_event(adapter->erp_dbf, 4,
 						 "pf_actenq_drpcp");
 			debug_event(adapter->erp_dbf, 4, &port->wwpn,
Index: HEAD/drivers/s390/scsi/zfcp_ext.h
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_ext.h
+++ HEAD/drivers/s390/scsi/zfcp_ext.h
@@ -1,22 +1,22 @@
-/* 
+/*
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
  * (C) Copyright IBM Corp. 2002, 2006
- * 
- * This program is free software; you can redistribute it and/or modify 
- * it under the terms of the GNU General Public License as published by 
- * the Free Software Foundation; either version 2, or (at your option) 
- * any later version. 
- * 
- * This program is distributed in the hope that it will be useful, 
- * but WITHOUT ANY WARRANTY; without even the implied warranty of 
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
- * GNU General Public License for more details. 
- * 
- * You should have received a copy of the GNU General Public License 
- * along with this program; if not, write to the Free Software 
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #ifndef ZFCP_EXT_H
Index: HEAD/drivers/s390/scsi/zfcp_fsf.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_fsf.c
+++ HEAD/drivers/s390/scsi/zfcp_fsf.c
@@ -80,10 +80,10 @@ static const char zfcp_act_subtable_type
 /*
  * function:	zfcp_fsf_req_alloc
  *
- * purpose:     Obtains an fsf_req and potentially a qtcb (for all but 
+ * purpose:     Obtains an fsf_req and potentially a qtcb (for all but
  *              unsolicited requests) via helper functions
  *              Does some initial fsf request set-up.
- *              
+ *
  * returns:	pointer to allocated fsf_req if successfull
  *              NULL otherwise
  *
@@ -192,7 +192,7 @@ void zfcp_fsf_req_dismiss_all(struct zfc
  * returns:	0 - success
  *		!0 - failure
  *
- * context:	
+ * context:
  */
 int
 zfcp_fsf_req_complete(struct zfcp_fsf_req *fsf_req)
@@ -214,8 +214,8 @@ zfcp_fsf_req_complete(struct zfcp_fsf_re
 	}
 
 	/*
-	 * fsf_req may be deleted due to waking up functions, so 
-	 * cleanup is saved here and used later 
+	 * fsf_req may be deleted due to waking up functions, so
+	 * cleanup is saved here and used later
 	 */
 	if (likely(fsf_req->status & ZFCP_STATUS_FSFREQ_CLEANUP))
 		cleanup = 1;
@@ -259,9 +259,9 @@ zfcp_fsf_req_complete(struct zfcp_fsf_re
  *		and initiates appropriate actions
  *		(usually calling FSF command specific handlers)
  *
- * returns:	
+ * returns:
  *
- * context:	
+ * context:
  *
  * locks:
  */
@@ -638,7 +638,7 @@ zfcp_fsf_link_down_info_eval(struct zfcp
  *
  * purpose:	calls the appropriate command specific handler
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_req_dispatch(struct zfcp_fsf_req *fsf_req)
@@ -854,7 +854,7 @@ zfcp_fsf_status_read_port_closed(struct 
  *
  * purpose:	is called for finished Open Port command
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_status_read_handler(struct zfcp_fsf_req *fsf_req)
@@ -1088,7 +1088,7 @@ zfcp_fsf_status_read_handler(struct zfcp
  * returns:	address of initiated FSF request
  *		NULL - request could not be initiated
  *
- * FIXME(design): should be watched by a timeout !!! 
+ * FIXME(design): should be watched by a timeout !!!
  * FIXME(design) shouldn't this be modified to return an int
  *               also...don't know how though
  */
@@ -1157,7 +1157,7 @@ zfcp_fsf_abort_fcp_command(unsigned long
  *
  * purpose:	is called for finished Abort FCP Command request
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *new_fsf_req)
@@ -2437,10 +2437,10 @@ zfcp_fsf_exchange_port_data_handler(stru
 /*
  * function:    zfcp_fsf_open_port
  *
- * purpose:	
+ * purpose:
  *
  * returns:	address of initiated FSF request
- *		NULL - request could not be initiated 
+ *		NULL - request could not be initiated
  */
 int
 zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
@@ -2501,7 +2501,7 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
  *
  * purpose:	is called for finished Open Port command
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_open_port_handler(struct zfcp_fsf_req *fsf_req)
@@ -3103,7 +3103,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
  *
  * purpose:	is called for finished Open LUN command
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_open_unit_handler(struct zfcp_fsf_req *fsf_req)
@@ -3366,7 +3366,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
  * purpose:
  *
  * returns:	address of fsf_req - request successfully initiated
- *		NULL - 
+ *		NULL -
  *
  * assumptions: This routine does not check whether the associated
  *              remote port/lun has already been opened. This should be
@@ -3828,7 +3828,7 @@ zfcp_fsf_send_fcp_command_task_managemen
  *
  * purpose:	is called for finished Send FCP Command
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_send_fcp_command_handler(struct zfcp_fsf_req *fsf_req)
@@ -4065,7 +4065,7 @@ zfcp_fsf_send_fcp_command_handler(struct
  *
  * purpose:	evaluates FCP_RSP IU
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
@@ -4292,7 +4292,7 @@ zfcp_fsf_send_fcp_command_task_handler(s
  *
  * purpose:	evaluates FCP_RSP IU
  *
- * returns:	
+ * returns:
  */
 static int
 zfcp_fsf_send_fcp_command_task_management_handler(struct zfcp_fsf_req *fsf_req)
@@ -4735,7 +4735,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 	INIT_LIST_HEAD(&fsf_req->list);
 	init_timer(&fsf_req->timer);
 
-	/* initialize waitqueue which may be used to wait on 
+	/* initialize waitqueue which may be used to wait on
 	   this request completion */
 	init_waitqueue_head(&fsf_req->completion_wq);
 
Index: HEAD/drivers/s390/scsi/zfcp_fsf.h
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_fsf.h
+++ HEAD/drivers/s390/scsi/zfcp_fsf.h
@@ -1,22 +1,22 @@
-/* 
+/*
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
  * (C) Copyright IBM Corp. 2002, 2006
- * 
- * This program is free software; you can redistribute it and/or modify 
- * it under the terms of the GNU General Public License as published by 
- * the Free Software Foundation; either version 2, or (at your option) 
- * any later version. 
- * 
- * This program is distributed in the hope that it will be useful, 
- * but WITHOUT ANY WARRANTY; without even the implied warranty of 
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
- * GNU General Public License for more details. 
- * 
- * You should have received a copy of the GNU General Public License 
- * along with this program; if not, write to the Free Software 
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #ifndef FSF_H
Index: HEAD/drivers/s390/scsi/zfcp_qdio.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_qdio.c
+++ HEAD/drivers/s390/scsi/zfcp_qdio.c
@@ -176,10 +176,9 @@ zfcp_qdio_handler_error_check(struct zfc
                 * That is why we need to clear the link-down flag
                 * which is set again in case we have missed by a mile.
                 */
-               zfcp_erp_adapter_reopen(
-                       adapter, 
-                       ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-                       ZFCP_STATUS_COMMON_ERP_FAILED);
+		zfcp_erp_adapter_reopen(adapter,
+				       ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
+				       ZFCP_STATUS_COMMON_ERP_FAILED);
 	}
 	return retval;
 }
Index: HEAD/drivers/s390/scsi/zfcp_scsi.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_scsi.c
+++ HEAD/drivers/s390/scsi/zfcp_scsi.c
@@ -1,22 +1,22 @@
-/* 
+/*
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
  * (C) Copyright IBM Corp. 2002, 2006
- * 
- * This program is free software; you can redistribute it and/or modify 
- * it under the terms of the GNU General Public License as published by 
- * the Free Software Foundation; either version 2, or (at your option) 
- * any later version. 
- * 
- * This program is distributed in the hope that it will be useful, 
- * but WITHOUT ANY WARRANTY; without even the implied warranty of 
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
- * GNU General Public License for more details. 
- * 
- * You should have received a copy of the GNU General Public License 
- * along with this program; if not, write to the Free Software 
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_SCSI
@@ -101,7 +101,7 @@ zfcp_get_fcp_dl_ptr(struct fcp_cmnd_iu *
 		((unsigned char *) fcp_cmd +
 		 sizeof (struct fcp_cmnd_iu) + additional_length);
 	/*
-	 * fcp_dl_addr = start address of fcp_cmnd structure + 
+	 * fcp_dl_addr = start address of fcp_cmnd structure +
 	 * size of fixed part + size of dynamically sized add_dcp_cdb field
 	 * SEE FCP-2 documentation
 	 */
@@ -194,7 +194,7 @@ static void zfcp_scsi_slave_destroy(stru
 				"address %p\n", sdpnt);
 }
 
-/* 
+/*
  * called from scsi midlayer to allow finetuning of a device.
  */
 static int
@@ -372,7 +372,7 @@ zfcp_unit_lookup(struct zfcp_adapter *ad
 
 /**
  * zfcp_scsi_eh_abort_handler - abort the specified SCSI command
- * @scpnt: pointer to scsi_cmnd to be aborted 
+ * @scpnt: pointer to scsi_cmnd to be aborted
  * Return: SUCCESS - command has been aborted and cleaned up in internal
  *          bookkeeping, SCSI stack won't be called for aborted command
  *         FAILED - otherwise
Index: HEAD/drivers/s390/scsi/zfcp_sysfs_unit.c
===================================================================
--- HEAD.orig/drivers/s390/scsi/zfcp_sysfs_unit.c
+++ HEAD/drivers/s390/scsi/zfcp_sysfs_unit.c
@@ -139,7 +139,7 @@ static struct attribute_group zfcp_unit_
 	.attrs = zfcp_unit_attrs,
 };
 
-/** 
+/**
  * zfcp_sysfs_create_unit_files - create sysfs unit files
  * @dev: pointer to belonging device
  *
@@ -151,7 +151,7 @@ zfcp_sysfs_unit_create_files(struct devi
 	return sysfs_create_group(&dev->kobj, &zfcp_unit_attr_group);
 }
 
-/** 
+/**
  * zfcp_sysfs_remove_unit_files - remove sysfs unit files
  * @dev: pointer to belonging device
  *

