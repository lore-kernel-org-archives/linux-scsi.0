From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: I/O Request [Elevator; Clustering; Scatter-Gather]
Date: Tue, 4 Mar 2003 09:14:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030304091451.1dc4c4ea.Scsi@PragmaSoft.com>
References: <20030304133201.18619.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030304133201.18619.qmail@mail.com>
List-Id: linux-scsi@vger.kernel.org
To: David Anderson <david-anderson2003@mail.com>
Cc: linux-scsi@vger.kernel.org

My understanding ... which may be misguided ...

Elevator: If three different users post read requests for Logical Block #1, #32678, and #4 respectively then it will be more efficient to sort the requests and process them in the sequence #1, #4, #32678 as it minimizes the disk seeking time/distance.

Clustering: "Combines multiple requests to adjecent blocks into a single request".  I am not personally familiar with if/where this is done in the SCSI subsystem, but sounds vaguely reasonable (if you have already sorted requests for "Elevator").

Scatter/Gather: In my experience, this refers to the ability of a low level adapter to "gather" multiple pieces of a single disk request which are located in different (non-contiguous) areas of physical memory.  This is typically done with some type of memory mapping or a direct memory access (DMA) mechanism that can sequence through a list of blocks.  Intuitively, it would seem that Scatter/Gather capability would be required to effectively implement "Clustering".

Hope this helps.

Regards, Scott.

