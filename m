From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Writing to tape from C system calls
Date: Fri, 12 Dec 2003 11:38:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03Dec12.113758est.332161@cyborg.cybernetics.com>
References: <002d01c3c0cb$85c266f0$7b00a8c0@pluto>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:275 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261298AbTLLQiA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 11:38:00 -0500
In-Reply-To: <002d01c3c0cb$85c266f0$7b00a8c0@pluto>
List-Id: linux-scsi@vger.kernel.org
To: 'Ujval Lodha' <ujval@gdc-tech.com>, linux-scsi@vger.kernel.org

> Any material that would help understand tape devices and
> tape as a medium - filemarks, setmarks, and the order of
> operations one is expected to perform.

Try the "SCSI-3 Stream Commands (SSC)" and "SCSI Stream Commands - 2
(SSC-2)" specifications available at http://www.t10.org/drafts.htm.
They give a nice general overview of tape technology in the opening
section.

Anthony J. Battersby
Cybernetics

