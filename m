From: "David Anderson" <david-anderson2003@mail.com>
Subject: I/O Request [Elevator; Clustering; Scatter-Gather]
Date: Tue, 04 Mar 2003 08:32:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030304133201.18619.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


Hi,
I have been going through some documentation that talks of clustering, scatter-gather and elevator being used to improve performance. I am confused between these :

This is what I have understood :
Elevator
The job of the elevator is to sort I/O requests to disk drives in such a way that the disk head moving in the same direction for maximum performance. Have been able to locate the code for the same.

Clustering
Combines multiple requests to adjecent blocks into a single request. Have not been able to find the code which carries this out. Any clue on where this is done in the linux source code ??

Do Clustering of request and scatter-gather mean the same ?? Confused to the core... Kindly help me ...

Thanks and Regards,
David Anderson
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

