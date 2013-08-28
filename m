From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Wed, 28 Aug 2013 10:32:58 -0400
Message-ID: <20130828143258.GD15917@logfs.org>
References: <20130827220325.GB7293@logfs.org>
 <20130827221714.GC7293@logfs.org>
 <521DF0DA.10004@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60132 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab3H1QGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 12:06:49 -0400
Content-Disposition: inline
In-Reply-To: <521DF0DA.10004@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-scsi@vger.kernel.org

On Wed, 28 August 2013 14:45:14 +0200, Bart Van Assche wrote:
>=20
> Isn't this facility something that overlaps with what Wireshark can
> already do today ? Wireshark can already capture SCSI traces for
> several transport types (iSCSI, USB, ...). For other transports,
> e.g. FC, I'd prefer to see Wireshark being extended instead of
> adding more SCSI tracing mechanisms in the SCSI core.

Wireshark would be great if there was a reproducable testcase and a
developer could sit down for an afternoon and collect some traces.
But how would you deal with rare cases that require around a year to
reproduce per device and only matter when dealing with many devices?

J=C3=B6rn

--
Data expands to fill the space available for storage.
-- Parkinson's Law
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
